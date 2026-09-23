---
title: "RISC-V on NIXPKGS"
sub_title: "Porting NixOS to the SpacemiT K1 and K3, and making riscv64 usable in nixpkgs"
author: liberodark
theme:
  name: dark
  override:
    footer:
      style: template
      left: "{title}"
      center: "_{author}_"
      right: "{current_slide} / {total_slides}"
    slide_title:
      padding_top: 0
      padding_bottom: 1
---

<!--
// Run:            presenterm RISC_V__NixOS.md
// Same content as RISC_V__NixOS.pptx. Target: 5:00.
-->

Self presentation
===

<!-- column_layout: [1, 2] -->

<!-- column: 0 -->

<!-- new_line -->

**liberodark**

`github.com/liberodark`

<!-- column: 1 -->

<!-- new_line -->

IT architect, specialized on Linux

Just another NixOS contributor, since 2023

I also have been working on RISC-V for a few years now

<!-- reset_layout -->

<!-- end_slide -->

Why NixOS on RISC-V?
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

**Reproducible builds**

The same nixpkgs revision gives the same result on every machine.

<!-- new_line -->

**Hardware support is declarative**

Kernel, patches and device tree live in one nixos-hardware module.

<!-- column: 1 -->

**Native builds on real hardware**

My riscv64 packages are built and tested directly on K3 boards, not cross-compiled.

<!-- new_line -->

**One fix unblocks many packages**

A fix merged in nixpkgs unblocks everything that depends on it. My builders share their binary caches, so servers can deploy riscv64 applications without rebuilding anything.

<!-- reset_layout -->

<!-- end_slide -->

How it began
===

<!-- new_line -->

**1 ·** I started porting NixOS to the SpacemiT K1, then moved to the SpacemiT K3.

<!-- pause -->

**2 ·** After porting the K3 with the vendor kernel (SpacemiT), I successfully brought it to the mainline kernel.

<!-- pause -->

**3 ·** To do so, I had to create custom patches that did not exist yet.

<!-- pause -->

**4 ·** nixos-hardware: modules for the K3 and its variants.

<!-- end_slide -->

From K1 to K3: why it matters
===

|                | SpacemiT K1         | SpacemiT K3                   |
|----------------|---------------------|-------------------------------|
| CPU            | 8 × X60, 1.6 GHz    | 8 × X100, 2.4 GHz             |
| ISA profile    | RVA22               | RVA23                         |
| Memory         | up to 16 GB LPDDR4X | up to 32 GB LPDDR5            |
| Storage / I/O  | PCIe 2.1            | PCIe Gen3, NVMe, UFS, 10 GbE  |
| Virtualization | no                  | yes                           |

<!-- pause -->

**Why the K3 for NixOS?**

<!-- column_layout: [1, 1, 1] -->

<!-- column: 0 -->

**RVA23**

The profile the RISC-V ecosystem now targets. Ubuntu uses RVA23 as its baseline since 25.10, and Ubuntu 26.04 LTS officially supports the K3.

<!-- column: 1 -->

**Native builds**

Big packages (GHC, .NET, Node.js) can be built and tested on the board. The 32 GB version is needed: 8 or 16 GB is not enough for builds such as Node.js.

<!-- column: 2 -->

**Virtualization**

The hypervisor extension (RVH) makes KVM and libkrun possible.

<!-- reset_layout -->

<!-- end_slide -->

And now: riscv64 in nixpkgs
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

**Languages & runtimes**

- **.NET 8 / 9 / 10** `#557475`
- **GHC 9.6.6** `#549823`
- **Dart** `#555733`
- **Deno** `#533574`
- **Node.js 22** `#555658`
- **Node.js 24** `#539503`
- **Temurin (Java)** `#554603`
- **Gradle** `#550010`

<!-- column: 1 -->

**Infrastructure**

- **Proxmox VE** (proxmox-nixos) `#248`
- **GitLab** `#565242`
- **Ceph 20.2** `#560645`
- **libkrun** `#545448`
- **CRIU** `#545342`
- **BIND** `#551604`

**Libraries**

- **libgcrypt** `#542494`
- **ANGLE** `#540665`
- **NumPy** `#523194`

<!-- reset_layout -->

_+ pdfium, ffmpeg, schroedinger, httpcore, PostgreSQL…_

<!-- end_slide -->

Builders, Hydra and binary caches
===

<!-- column_layout: [1, 1] -->

<!-- column: 0 -->

**3 RISC-V builders on SpacemiT K3, running NixOS**

build05, build06, build07.ynh.ovh

<!-- new_line -->

**Configuration**

`github.com/liberodark/nix-community-builder`

<!-- column: 1 -->

**My Hydra instance** builds riscv64 packages on these machines

<!-- new_line -->

**Each builder serves its Nix store** as a binary cache over HTTPS (Harmonia)

<!-- reset_layout -->

<!-- pause -->

**To use them, in your NixOS configuration:**

```nix
nix.settings = {
  substituters = [
    "https://build05.ynh.ovh"
    "https://build06.ynh.ovh"
    "https://build07.ynh.ovh"
  ];
  trusted-public-keys = [
    "build05.ynh.ovh:bLxWKPjbKYOFxqrjOxv+cdwS3kFLuHEf1k6j8fAxbzM="
    "build06.ynh.ovh:bPg6x17ztNd3uMxdclDvdJpTl2pwLiTdHTt9ymTNoMU="
    "build07.ynh.ovh:+FpUDKUYk4H9uzLgtbE0MHOx+5Nm7YEFBrJJGiQ9O8U="
  ];
};
```

<!-- end_slide -->

Goals and what's next
===

<!-- incremental_lists: true -->
<!-- list_item_newlines: 2 -->

- Make NixOS 26.05 and 26.11 usable on RISC-V
- nixos-hardware support for the K3 and its variants
- Improve evaluation in nixpkgs in general
- Next architecture: loongarch64, once riscv64 is done

<!-- incremental_lists: false -->

<!-- end_slide -->

Special thanks to...
===

| Who                 | For                    | GitHub                          |
|---------------------|------------------------|---------------------------------|
| **Gaétan Lepage**   | supporting my work     | `github.com/GaetanLepage`       |
| **Mic92**           | the PR reviews         | `github.com/Mic92`              |
| **Wegank**          | the PR reviews         | `github.com/Wegank`             |
| **Colemickens**     | the hardware tests     | `github.com/Colemickens`        |
| **wolfgangwalther** | the GHC part           | `github.com/wolfgangwalther`    |
| **corngood**        | the help on .NET       | `github.com/corngood`           |

