# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys
sys.path.insert(0, os.path.abspath('../../_packages/sphinx-extensions/current/src/sphinxcontrib'))

import dylan.themes as dylan_themes

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'Curl'
copyright = '2025, Dylan Hackers'
author = 'Dylan Hackers'
release = '0.0.1'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    'dylan.domain',
    'sphinx_copybutton',
    'sphinxcontrib.examplecode'
]

templates_path = ['_templates']
exclude_patterns = []



# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'furo'
html_theme_options = {
    'source_repository': 'https://github.com/fraya/dylan-curl',
    'source_branch': 'main',
    'source_directory': 'documentation/source',
}
html_static_path = ['_static']
