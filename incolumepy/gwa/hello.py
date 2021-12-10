#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = "@britodfbr"  # pragma: no cover


def hello(name: str = None, greater: bool = False):
    name = name or "Visitor"
    period = "!" if greater else "."
    return f"Hello {name}{period}"
