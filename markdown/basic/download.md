<heading><h1>Downloads</h1></heading>

D code can be developed with a number of
<abbr title="Integrated Development Environment">IDEs</abbr>
and compilers. Choose the option most appropriate for your
usage.

<h2 id="dmd">DMD</h2>

DMD is the Digital Mars reference D compiler.

If you are new to D or are unsure about which
compiler to use, DMD should be your first choice.

<h3 id="installing-dmd">Installing DMD</h3>

A variety of installers are available for DMD.
Choose the option which best fits your platform.

<ul class="download-list dmd2">
    <li>
        <span class="links"><a href="http://downloads.dlang.org/releases/2014/dmd-2.065.0.exe">Windows</a></span>
        <span class="architectures">i386</span>
    </li>
    <li>
        <span class="links"><a href="http://downloads.dlang.org/releases/2014/dmd.2.065.0.dmg">Mac OSX</a></span>
        <span class="architectures">x86_64</span>
    </li>
    <li>
        <span class="links"><a href="http://downloads.dlang.org/releases/2014/dmd_2.065.0-0_i386.deb">Debian/Ubuntu</a></span>
        <span class="architectures">i386</span>
    </li>
    <li>
        <span class="links"><a href="http://downloads.dlang.org/releases/2014/dmd_2.065.0-0_amd64.deb">Debian/Ubuntu</a></span>
        <span class="architectures">x86_64</span>
    </li>
    <li>
        <span class="links"><a href="http://downloads.dlang.org/releases/2014/dmd-2.065.0-0.fedora.i386.rpm">Fedora</a></span>
        <span class="architectures">i386</span>
    </li>
    <li>
        <span class="links"><a href="http://downloads.dlang.org/releases/2014/dmd-2.065.0-0.fedora.x86_64.rpm">Fedora</a></span>
        <span class="architectures">x86_64</span>
    </li>
    <li>
        <span class="links"><a href="http://downloads.dlang.org/releases/2014/dmd-2.065.0-0.openSUSE.i386.rpm">openSUSE</a></span>
        <span class="architectures">i386</span>
    </li>
    <li>
        <span class="links"><a href="http://downloads.dlang.org/releases/2014/dmd-2.065.0-0.openSUSE.x86_64.rpm">openSUSE</a></span>
        <span class="architectures">x86_64</span>
    </li>
</ul>

A package containing binaries for all platforms is also available.

<ul class="download-list dmd2">
    <li>
        <span class="links"><a href="http://downloads.dlang.org/releases/2014/dmd.2.065.0.zip">All Platforms</a></span>
        <span class="architectures">i386, x86_64</span>
    </li>
</ul>

<h2 id="gdc">GDC</h2>

GDC is a D compiler which uses
[GCC](https://gcc.gnu.org/ "The GNU Compiler Collection")
as its backend. By using GCC as its backend, GDC can target platforms which
GCC targets, and take advantage of compiler optimisations in GCC.

<ul class="download-list gdc">
    <li>
        <span class="links"><a href="http://gdcproject.org/downloads/">Binaries</a></span>
        <span class="architectures">i386, x86_64, armel, armhf</span>
    </li>
    <li>
        <span class="links"><a href="http://wiki.dlang.org/GDC/Installation">Source</a></span>
        <span class="architectures">
            i386, x86_64, armel, armhf, mips, mipsel,
            powerpc, ia64, s390, sparc
        </span>
    </li>
</ul>

<h2 id="ldc">LDC</h2>

LDC is a D compiler which uses [LLVM](http://llvm.org) as its backend.
By using LLVM as its backend, LDC is able to generate highly
optimised D code for a number of architectures.

The current LDC version is *0.12.1*,
which currently supports version *2.063.2*
of the D programming language.

<ul class="download-list ldc">
    <li>
        <span class="links">
            <a href="http://github.com/ldc-developers/ldc/releases/download/v0.12.1/ldc2-0.12.1-mingw-x86.zip">Windows .zip (19 MB)</a>
            <a href="http://github.com/ldc-developers/ldc/releases/download/v0.12.1/ldc2-0.12.1-mingw-x86.7z">.7z (9 MB)</a>
        </span>
        <span class="architectures">i386</span>
    </li>
    <li>
        <span class="links">
            <a href="http://github.com/ldc-developers/ldc/releases/download/v0.12.1/ldc2-0.12.1-osx-x86_64.tar.gz">Mac OSX 10.7+ .tar.gz (28 MB)</a>
            <a href="http://github.com/ldc-developers/ldc/releases/download/v0.12.1/ldc2-0.12.1-osx-x86_64.tar.xz">.tar.xz (12 MB)</a>
        </span>
        <span class="architectures">x86_64</span>
    </li>
    <li>
        <span class="links">
            <a href="http://github.com/ldc-developers/ldc/releases/download/v0.12.1/ldc2-0.12.1-linux-x86.tar.gz">Linux .tar.gz (18 MB)</a>
            <a href="http://github.com/ldc-developers/ldc/releases/download/v0.12.1/ldc2-0.12.1-linux-x86.tar.xz">.tar.xz (9 MB)</a>
        </span>
        <span class="architectures">i386</span>
    </li>
    <li>
        <span class="links">
            <a href="http://github.com/ldc-developers/ldc/releases/download/v0.12.1/ldc2-0.12.1-linux-x86_64.tar.gz">Linux .tar.gz (29 MB)</a>
            <a href="http://github.com/ldc-developers/ldc/releases/download/v0.12.1/ldc2-0.12.1-linux-x86_64.tar.xz">.tar.xz (12 MB)</a>
        </span>
        <span class="architectures">x86_64</span>
    </li>
    <li>
        <span class="links"><a href="http://github.com/ldc-developers/ldc/releases/download/v0.12.1/ldc-0.12.1-src.tar.gz">Source .tar.gz (4 MB)</a></span>
        <span class="architectures">i386, x86_64</span>
    </li>
</ul>

<h2 id="visuald">VisualD</h2>

VisualD is a Visual Studio plugin for the D programming language,
providing support for build D projects in Visual Studio.

The current VisualD version is *0.3.37*,
and it supports Visual Studio 2005, 2008, 2010, 2012, and 2013,
in addition to free [Visual Studio Shells](http://www.microsoft.com/en-gb/download/details.aspx?id=40777).

<ul class="download-list visuald">
    <li>
        <span class="links"><a href="https://github.com/D-Programming-Language/visuald/releases/download/v0.3.37/VisualD-v0.3.37.exe">Windows</a></span>
        <span class="architectures">i386, x86_64</span>
    </li>
</ul>

<h2 id="dmd1">DMD &ndash; Version 1</h2>

Downloads for version 1 of the D programming language are available here.

**Please note:** official support for version 1 of the D programming langauge
has been discontinued effective December 31, 2012.

<ul class="download-list dmd1">
    <li>
        <span class="links"><a href="http://ftp.digitalmars.com/dinstaller.exe">Windows</a></span>
        <span class="architectures">i386</span>
    </li>
    <li>
        <span class="links"><a href="http://dlang.org/dmd.1.076.dmg">Mac OSX</a></span>
        <span class="architectures">x86_64</span>
    </li>
    <li>
        <span class="links"><a href="http://ftp.digitalmars.com/dmd_1.076-0_i386.deb">Debian/Ubuntu</a></span>
        <span class="architectures">i386</span>
    </li>
    <li>
        <span class="links"><a href="http://ftp.digitalmars.com/dmd_1.076-0_amd64.deb">Debian/Ubuntu</a></span>
        <span class="architectures">x86_64</span>
    </li>
    <li>
        <span class="links"><a href="http://ftp.digitalmars.com/dmd-1.076-0.fedora.i386.rpm">Fedora</a></span>
        <span class="architectures">i386</span>
    </li>
    <li>
        <span class="links"><a href="http://ftp.digitalmars.com/dmd-1.076-0.fedora.x86_64.rpm">Fedora</a></span>
        <span class="architectures">x86_64</span>
    </li>
    <li>
        <span class="links"><a href="http://ftp.digitalmars.com/dmd-1.076-0.openSUSE.i386.rpm">openSUSE</a></span>
        <span class="architectures">i386</span>
    </li>
    <li>
        <span class="links"><a href="http://ftp.digitalmars.com/dmd-1.076-0.openSUSE.x86_64.rpm">openSUSE</a></span>
        <span class="architectures">x86_64</span>
    </li>
</ul>

A package containing binaries for all platforms is also available.

<ul class="download-list dmd1">
    <li>
        <span class="links"><a href="http://ftp.digitalmars.com/dmd.1.076.zip">All Platforms</a></span>
        <span class="architectures">i386, x86_64</span>
    </li>
    <li>
        <span class="links"><a href="http://ftp.digitalmars.com/dmd.1.030.zip">All Platforms (1.030)</a></span>
        <span class="architectures">i386, x86_64</span>
    </li>
</ul>

<h2 id="dmc">DMC &ndash; Digital Mars C and C++ Compiler</h2>

Digital Mars offers a C and C++ compiler, which DMD uses on 32-bit
Windows for compiling and linking D programs.

<ul class="download-list dmc">
    <li>
        <span class="links"><a href="http://downloads.dlang.org/other/dm857c.zip">Windows</a></span>
        <span class="architectures">i386</span>
    </li>
</ul>

<h2 id="language-specifications">Language Specifications</h2>

Language specifications are available.

<ul class="download-list docs">
    <li>
        <span class="links"><a href="http://digitalmars.com/d/2.0/dlangspec.mobi">D Programming Language Specification 2.0</a></span>
    </li>
    <li>
        <span class="links"><a href="http://www.prowiki.org/upload/duser/spec_DMD_1.00.pdf">DMD 1.0 pdf</a></span>
    </li>
</ul>

<h2 id="other">Other</h2>

<ul class="download-list other">
    <li>
        <span class="links"><a href="http://www.digitalmars.com/download/freecompiler.html">C and C++ compiler downloads</a></span>
    </li>
    <li>
        <span class="links"><a href="http://ftp.digitalmars.com/dmdscript.zip">DMDScript source</a></span>
    </li>
    <li>
        <span class="links"><a href="http://ftp.classicempire.com/empiresrc.zip">Empire 2.01 source</a></span>
    </li>
</ul>

A DMD2 compatible CURL binary is available, for use with D network code on
Windows.

*See also:* [Building Curl on Windows](http://wiki.dlang.org/Curl_on_Windows)

<ul class="download-list other">
    <li>
        <span class="links"><a href="http://downloads.dlang.org/other/curl-7.24.0-dmd-win32.zip">DMD2 compatible cURL 7.24.0</a></span>
    </li>
</ul>
