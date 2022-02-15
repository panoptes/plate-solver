import time
import typer
from pathlib import Path

from panoptes.utils.library import load_module
from watchdog.observers import Observer


class Watcher:

    def __init__(self, directory: Path, handler: str = 'handler'):
        self.handler = load_module(handler).Handler()

        self.observer = Observer()
        self.directory = directory

    def run(self):
        self.observer.schedule(self.handler, str(self.directory), recursive=True)
        self.observer.start()
        try:
            while True:
                time.sleep(1)
        except Exception:
            self.observer.stop()
            print("Error")

        self.observer.join()


def main(directory: Path, handler: str = 'handler'):
    typer.echo(f'Starting watchdog on {directory}')
    w = Watcher(directory=directory, handler=handler)
    w.run()


if __name__ == '__main__':
    typer.run(main)
