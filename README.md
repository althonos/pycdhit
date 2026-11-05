# PyCDHIT [![Stars](https://img.shields.io/github/stars/althonos/pycdhit.svg?style=social&maxAge=3600&label=Star)](https://github.com/althonos/pycdhit/stargazers)

*[Cython](https://cython.org/) bindings and Python interface to [CD-HIT](https://sites.google.com/view/cd-hit), an accelerated sequence clustering program..*

[![Actions](https://img.shields.io/github/actions/workflow/status/althonos/pycdhit/test.yml?branch=main&logo=github&style=flat-square&maxAge=300)](https://github.com/althonos/pycdhit/actions)
[![Coverage](https://img.shields.io/codecov/c/gh/althonos/pycdhit?style=flat-square&maxAge=3600&logo=codecov)](https://codecov.io/gh/althonos/pycdhit/)
[![License](https://img.shields.io/badge/license-GPLv3-blue.svg?style=flat-square&maxAge=2678400)](https://choosealicense.com/licenses/gpl-3.0/)
[![PyPI](https://img.shields.io/pypi/v/pycdhit.svg?style=flat-square&maxAge=3600&logo=PyPI)](https://pypi.org/project/pycdhit)
[![Bioconda](https://img.shields.io/conda/vn/bioconda/pycdhit?style=flat-square&maxAge=3600&logo=anaconda)](https://anaconda.org/bioconda/pycdhit)
[![AUR](https://img.shields.io/aur/version/python-pycdhit?logo=archlinux&style=flat-square&maxAge=3600)](https://aur.archlinux.org/packages/python-pycdhit)
[![Wheel](https://img.shields.io/pypi/wheel/pycdhit.svg?style=flat-square&maxAge=3600)](https://pypi.org/project/pycdhit/#files)
[![Python Versions](https://img.shields.io/pypi/pyversions/pycdhit.svg?style=flat-square&maxAge=600&logo=python)](https://pypi.org/project/pycdhit/#files)
[![Python Implementations](https://img.shields.io/pypi/implementation/pycdhit.svg?style=flat-square&maxAge=600&label=impl)](https://pypi.org/project/pycdhit/#files)
[![Source](https://img.shields.io/badge/source-GitHub-303030.svg?maxAge=2678400&style=flat-square)](https://github.com/althonos/pycdhit/)
[![Mirror](https://img.shields.io/badge/mirror-EMBL-009f4d?style=flat-square&maxAge=2678400)](https://git.embl.de/larralde/pycdhit/)
[![Issues](https://img.shields.io/github/issues/althonos/pycdhit.svg?style=flat-square&maxAge=600)](https://github.com/althonos/pycdhit/issues)
[![Docs](https://img.shields.io/readthedocs/pycdhit/latest?style=flat-square&maxAge=600)](https://pycdhit.readthedocs.io)
[![Changelog](https://img.shields.io/badge/keep%20a-changelog-8A0707.svg?maxAge=2678400&style=flat-square)](https://github.com/althonos/pycdhit/blob/main/CHANGELOG.md)
[![Downloads](https://img.shields.io/badge/dynamic/regex?url=https%3A%2F%2Fpepy.tech%2Fprojects%2Fpycdhit&search=%5B0-9%5D%2B.%5B0-9%5D%2B(k%7CM)&style=flat-square&label=downloads&color=303f9f&cacheSeconds=86400)](https://pepy.tech/project/pycdhit)


## 🗺️ Overview

[CD-HIT](https://sites.google.com/view/cd-hit) is a fast method published in
2006 by Weizhong Li[\[1\]](#ref1) for clustering biological sequences. 
Its clustering approach uses a greedy clustering algorithm and common word counting 
to approximate sequence identity. Extensive parallelization later implemented by 
Limin Fu[\[2\]](#ref2) allow for a quasi-linear speed-up for up to 8 CPU cores, 
a typical figure for consumer hardware.

PyCDHIT is a Python module that provides bindings to CD-HIT
using [Cython](https://cython.org/). It implements a user-friendly, Pythonic
interface to cluster biological sequences using different parameters and access
results directly. It interacts with the CD-HIT library interface, which has
the following advantages:

- **single dependency**: PyCDHIT is distributed as a Python package, so you
  can add it as a dependency to your project, and stop worrying about the
  CD-HIT binaries being present on the end-user machine.
- **no intermediate files**: Everything happens in memory, through Python 
  objects you control, so you don't have to invoke the CD-HIT CLI using a
  sub-process and temporary files.


<!-- ## 🔧 Installing

PyCDHIT can be installed directly from [PyPI](https://pypi.org/project/pycdhit/),
which hosts some pre-built wheels for common architectures & operating systems,
as well as the code required to compile from source with Cython:
```console
$ pip install pycdhit
```

PyCDHIT is also available as a [Bioconda](https://bioconda.github.io/)
package:
```console
$ conda install -c bioconda pycdhit
```

Otherwise, have a look at the [Installation page](https://pycdhit.readthedocs.io/en/stable/guide/install.html) 
of the [online documentation](https://pycdhit.readthedocs.io/) -->

## 💡 Example

Let's create some sequences in memory, then cluster them with CD-HIT and default 
parameter, and finally print result:

```python
import pycdhit

sequences = [
  "MKALIVLGLVLLSVTVQGKVFERCELARTLKRLGMDGYRGISLANWMCLAKWESGYNTRATNYNAGDRSTDYGIFQINSRYWCNDGKTPGAVNACHLSCSALLQDNIADAVACAKRVVRDPQGIRAWVAWRNRCQNRDVRQYVQGCGV",
  "MKALIVLGLVLLSVMVQGKVFERCELARTLKRLGMDGYRGISLANWMCLAKWESGYNTRATNYNAGDRSTDYGIFQINSRYWCNDGKTPGAVNACHLSCSALLQDNIADAVACAKRVVRDPQGIRAWVAWRNRCQNRDVRQYVQGCGV",
  "MMRFVPLFLACISLPAFQATEFTKCEVSHAIEDMDGYQGISLLEWTCVLFHTSGYDSQAIVKNNGSTEYGLFQISNRNWCKSSEFPESENICDISCDKFLDDELADDIVCAKKIVAIKGIDYWKAHKPMCSEKLEQWRCEKPGAPALVVPALNSETPVP",
  "MMSFFPLLLVGILFPAVQAKQLTKCALSHELNDLAGYRDITLPEWLCIIFHISGYDTQAIVKNSDHKEYGLFQINDKDFCESSTTVQSRNICDISCDKLLDDDLTDDIMCVKKILDIKGIDYWLAHKPLCSDKLEQWYCEAQ",
]

clustering = pycdhit.cluster(sequences)
print("clusters: ", list(clustering.clusters))
print("representatives: ", list(clustering.representatives))
```

This should output the following:
```
clusters: [0, 0, 1, 2]
representatives: [0, 2, 3]
```
i.e. the first two sequences belong to the same cluster (with representative being sequence #0)
while the two remaining ones form a singleton each. The format is similar to 
flat clusters returned by e.g. [`scipy.cluster.hierarchy.fcluster`](https://docs.scipy.org/doc/scipy-1.18.0/reference/generated/scipy.cluster.hierarchy.fcluster.html#fcluster)

<!-- ## 🧶 Thread-safety -->

<!-- ## ⏱️ Benchmarks -->

## 🔎 See Also

Using CD-HIT to cluster protein families? Then perhaps for the next steps you 
may be interested in aligning them, for instance with 
[`pyfamsa`](https://github.com/althonos/pyfamsa), a Python package wrapping
the [FAMSA 2](https://www.biorxiv.org/content/10.1101/2025.07.15.664876v1) aligner. 
Then you may want to build a profile HMM from the alignment, for instance 
with [`pyhmmer`](https://github.com/althonos/pyhmmer), a Python package 
which wraps [HMMER](http://hmmer.org/).


## 💭 Feedback

### ⚠️ Issue Tracker

Found a bug ? Have an enhancement request ? Head over to the 
[GitHub issue tracker](https://github.com/althonos/pycdhit/issues)
if you need to report or ask something. If you are filing in on a bug,
please include as much information as you can about the issue, and try to
recreate the same bug in a simple, easily reproducible situation.


### 🏗️ Contributing

Contributions are more than welcome! See
[`CONTRIBUTING.md`](https://github.com/althonos/pycdhit/blob/main/CONTRIBUTING.md)
for more details.


## 📋 Changelog

This project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html)
and provides a [changelog](https://github.com/althonos/pycdhit/blob/main/CHANGELOG.md)
in the [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) format.


## ⚖️ License

This library is provided under the [GNU General Public License v3.0](https://choosealicense.com/licenses/gpl-3.0/). 
CD-HIT is developed by [Weizhong Li's lab](https://github.com/weizhongli)
and is distributed under the terms of the [GNU General Public License v2.0](https://choosealicense.com/licenses/gpl-2.0/). 
See `vendor/cdhit/license.txt` for more information.

*This project is in no way not affiliated, sponsored, or otherwise endorsed
by the [CD-HIT authors](https://github.com/weizhongli). It was developed
by [Martin Larralde](https://github.com/althonos/) during his post-doctoral 
project at the [Idiap Research Institute](https://idiap.ch/en) in
the [Human-Centered Health AI](https://idiap.ch/en/research/groups/human-centered-health-ai) group*


## 📚 References

- <a id="ref1">\[1\]</a> Li, W., & Godzik, A. (2006). Cd-hit: a fast program for clustering and comparing large sets of protein or nucleotide sequences. *Bioinformatics (Oxford, England), 22(13)*, 1658–1659. [doi:10.1093/bioinformatics/btl158](https://doi.org/10.1093/bioinformatics/btl158). Epub 2006 May 26. [PMID:16731699](https://pubmed.ncbi.nlm.nih.gov/16731699/).
- <a id="ref2">\[2\]</a> Fu, L., Niu, B., Zhu, Z., Wu, S., & Li, W. (2012). CD-HIT: accelerated for clustering the next-generation sequencing data. *Bioinformatics (Oxford, England), 28(23)*, 3150–3152. [doi:10.1093/bioinformatics/bts565](https://doi.org/10.1093/bioinformatics/bts565) [PMID:23060610](https://pubmed.ncbi.nlm.nih.gov/23060610/)