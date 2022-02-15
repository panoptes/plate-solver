import time
import typer
from pathlib import Path

from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

from panoptes.utils.images import make_pretty_image
from panoptes.utils.images import cr2
from panoptes.utils.images import fits as fits_utils


class Handler(FileSystemEventHandler):

    @staticmethod
    def on_any_event(event, **kwargs):
        if event.event_type == 'created':
            filename = Path(event.src_path)
            typer.echo(f"Received created event for {filename}.")

            # Convert CR2
            if filename.suffix.lower() == '.cr2':
                typer.echo('Getting thumbnail from CR2')
                thumb_path = make_pretty_image(str(filename))
                typer.echo(f'Thumbnail saved to {thumb_path=}')

                typer.echo(f'Converting CR2 to FITS for {filename}')
                filename = cr2.cr2_to_fits(str(filename), remove_cr2=True)

            if filename.suffix.lower() == '.fits':
                typer.echo(f'Plate solving {filename}')
                try:
                    metadata = fits_utils.get_solve_field(filename)
                    filename = metadata['solved_fits_file']
                    typer.echo(f'Solved {filename}, replacing metadata.')
                except Exception as e:
                    typer.echo(f'Problem solving {filename=}: {e!r}')

                typer.echo(f'Compressing FITS file')
                filename = fits_utils.fpack(filename)
                typer.echo(f'Solved and compressed file created: {filename=}')


class Watcher:

    def __init__(self, directory: Path):
        self.observer = Observer()
        self.directory = directory

    def run(self):
        event_handler = Handler()
        self.observer.schedule(event_handler, str(self.directory), recursive=True)
        self.observer.start()
        try:
            while True:
                time.sleep(1)
        except Exception:
            self.observer.stop()
            print("Error")

        self.observer.join()


def main(directory: Path):
    typer.echo(f'Starting watchdog on {directory}')
    w = Watcher(directory=directory)
    w.run()


if __name__ == '__main__':
    typer.run(main)
