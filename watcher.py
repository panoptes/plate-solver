import os
from pathlib import Path

from watchfiles import watch
from panoptes.utils.images import fits as fits_utils

incoming_dir = os.getenv('INCOMING_DIR', '/incoming')
outgoing_dir = os.getenv('OUTGOING_DIR', '/outgoing')
solve_opts = os.getenv('SOLVE_OPTS',
                       '--guess-scale --cpulimit 90 --no-verify'
                       '--crpix-center --temp-axy --index-xyls none'
                       '--solved none --match none --rdls none'
                       '--corr none --downsample 4 --no-plots'
                       f'--dir {outgoing_dir}'
                       )


def main():
    """Listens to directories and handles FITS files."""
    for changes in watch(incoming_dir):
        print(changes)
        for change_type, path in changes:
            path = Path(path)
            print(change_type.name, path)
            if change_type.name == 'added' and path.exists():
                print(f'Received {path}')

                # Check for FITS files and plate-solve.p
                if path.suffix in ['.fits', '.fz']:
                    try:
                        solve_info = fits_utils.solve_field(str(path),
                                                            solve_opts=solve_opts.split(' '))
                        print(f'Solved {path}: {solve_info!r}')
                    except Exception as e:
                        print(f'Error processing {path}: {e}')


if __name__ == '__main__':
    main()
