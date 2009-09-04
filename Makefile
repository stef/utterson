# -*- make -*-
# FILE: "blog/Makefile"
# (C) 2009 by Stefan Marsiske, <stefan.marsiske@gmail.com>
# $Id:$

src:=$(shell /bin/ls -t posts/*.html)
SHELL:=/usr/bin/ksh
ITEMMAX:=15
TMPDIR=tmp

# move all files afterwards to www

all: index atom post sitemap static

index: $(src)
	echo $^

atom: $(src)
	echo $^

post: $(src) # move files from tmp to www/posts
	echo $^

sitemap: $(src) post index
	echo $^

static: layout/static/*
	static %
