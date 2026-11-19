# PES-VCS

A local version-control system written in C as a systems-programming lab. It explores the storage model behind version control: content-addressed objects, a staging index, directory trees, commits, and history traversal.

**Stack:** C · POSIX filesystem APIs · OpenSSL SHA-256 · Make

## Core components

| Component | Responsibility |
| --- | --- |
| [object.c](object.c) | Hash, write, read, and verify stored objects |
| [index.c](index.c) | Load, save, and update the staging index |
| [tree.c](tree.c) | Serialize directory trees and construct snapshots from the index |
| [commit.c](commit.c) | Serialize commits, update references, and walk history |
| [pes.c](pes.c) | Dispatch CLI commands |
| [pes.h](pes.h) | Shared structures and constants |

Objects are stored under `.pes/objects/` using SHA-256-derived paths. Commits refer to a root tree and, after the first commit, a parent commit.

## Build

Use a Linux environment with GCC, Make, and OpenSSL development headers. The course environment is Ubuntu 22.04.

```bash
git clone https://github.com/sidd2006/PES1UG24AM275-pes-vcs.git
cd PES1UG24AM275-pes-vcs
sudo apt update
sudo apt install -y build-essential libssl-dev
make all
```

## Try the CLI

Run in a fresh working copy:

```bash
export PES_AUTHOR="Your Name"
./pes init
./pes add README.md
./pes status
./pes commit -m "Create first snapshot"
./pes log
```

| Command | Purpose |
| --- | --- |
| `pes init` | Initialize local metadata |
| `pes add <file>...` | Stage files |
| `pes status` | Inspect index and working-directory state |
| `pes commit -m <message>` | Store a snapshot and advance the reference |
| `pes log` | Traverse commit history |

## Tests

```bash
make test
```

The [Makefile](Makefile) runs object/tree unit programs and [test_sequence.sh](test_sequence.sh). Use a disposable working copy for the lab test sequence and cleanup targets because they operate on the local `.pes` store.

## Scope and provenance

Built from a course-provided scaffold; source comments distinguish provided helpers from implementation tasks. The [original lab guide](docs/LAB_GUIDE.md) retains the teaching material and submission requirements.

This is an educational local VCS. It is not Git-compatible and provides no merge, remote synchronization, or checkout command.
