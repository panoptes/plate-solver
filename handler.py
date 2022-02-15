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

            file_type = filename.suffix.lower()

            # Convert CR2
            if file_type == '.cr2':
                typer.echo('Getting thumbnail from CR2')
                thumb_path = make_pretty_image(str(filename))
                typer.echo(f'Thumbnail saved to {thumb_path=}')

                typer.echo(f'Converting CR2 to FITS for {filename}')
                cr2.cr2_to_fits(str(filename), remove_cr2=True)

            if file_type == '.fits':
                typer.echo(f'Plate solving {filename}')
                try:
                    wcs0 = fits_utils.getwcs(str(filename))
                    if wcs0.is_celestial is False:
                        metadata = fits_utils.get_solve_field(filename)
                        filename = metadata['solved_fits_file']
                        typer.echo(f'Solved {filename}')
                except Exception as e:
                    typer.echo(f'Problem solving {filename=}: {e!r}')

                typer.echo(f'Compressing FITS file')
                filename = fits_utils.fpack(filename)
                typer.echo(f'Solved and compressed file created: {filename=}')
