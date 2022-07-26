import os
import subprocess
from pathlib import Path

from watchfiles import watch
from panoptes.utils import error
from panoptes.utils.images import fits as fits_utils
from panoptes.utils.images import cr2 as cr2_utils

incoming_dir = os.getenv('INCOMING_DIR', '/incoming')
outgoing_dir = os.getenv('OUTGOING_DIR', '/outgoing')
solve_opts = os.getenv('SOLVE_OPTS',
                       '--guess-scale --cpulimit 90 --no-verify'
                       ' --crpix-center --temp-axy --index-xyls none'
                       ' --solved none --match none --rdls none'
                       ' --corr none --downsample 4 --no-plots'
                       f' --dir {outgoing_dir}'
                       )


def main(timeout=180):
    """Listens to directories and handles FITS files."""
    for changes in watch(incoming_dir):
        print(changes)
        for change_type, path in changes:
            path = Path(path)
            if change_type.name == 'added' and path.exists():
                if path.suffix in ['.cr2']:
                    fits_path = cr2_utils.cr2_to_fits(path,
                                                      fits_fname=f'{path.with_suffix(".fits")}',
                                                      remove_cr2=True)
                    print(f'Converted {path} to {fits_path}')
                # Check for FITS files and plate-solve.
                elif path.suffix in ['.fits', '.fz']:
                    try:
                        proc = fits_utils.solve_field(str(path),
                                                      solve_opts=solve_opts.split(' '))
                        try:
                            # Timeout plus a small buffer.
                            output, errs = proc.communicate(timeout=timeout)
                        except subprocess.TimeoutExpired:
                            proc.kill()
                            output, errs = proc.communicate()
                            raise error.Timeout(f'Timeout while solving: {output!r} {errs!r}')
                        else:
                            if proc.returncode != 0:
                                print(f'Returncode: {proc.returncode}')
                            for log in [output, errs]:
                                if log and log > '':
                                    print(f'Output on {path}: {log}')

                            if proc.returncode == 3:
                                raise error.SolveError(f'solve-field not found: {output}')

                        print(f'Solved {path}')
                    except Exception as e:
                        print(f'Error processing {path}: {e}')


if __name__ == '__main__':
    main()
