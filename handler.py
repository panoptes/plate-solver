from pathlib import Path

import typer
from panoptes.utils.images import make_pretty_image, cr2, fits as fits_utils
from watchdog.events import FileSystemEventHandler


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
