import re

import pytest

from incolumepy.gwa import __root__, __version__, version_file

__author__ = "@britodfbr"  # pragma: no cover


def test_root():
    assert "/".join(__root__.parts[-3:]) == "incolumepy.gwa/incolumepy/gwa"


def test_version_file():
    assert version_file.name == "version.txt"


def test_version():
    assert re.fullmatch(r"\d+(.\d+){2}(-\w+.\d+)?", __version__, flags=re.I)


@pytest.mark.parametrize(
    "name, greater, expected",
    ["", False, "Hello Visitor."],
    ["", True, "Hello Visitor!"],
    ["Ada", False, "Hello Ada."],
    ["Ana", True, "Hello Ana!"],
)
def test_hello():
    ...
