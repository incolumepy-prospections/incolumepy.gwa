import pytest
import re
from incolumepy.gwa import __version__, __root__, version_file
__author__ = '@britodfbr'  # pragma: no cover
def test_root():
    assert '/'.join(__root__.parts[-3:]) == "incolumepy.gwa/incolumepy/gwa"
def test_version_file():
    assert version_file.name == 'version.txt'
def test_version():
    assert re.fullmatch(r"\d+(.\d+){2}(-\w+.\d+)?", __version__, flags=re.I)
def test_hello():
    ...
