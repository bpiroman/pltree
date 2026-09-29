#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';

sub print_tree {
    my ($dir, $prefix) = @_;
    $prefix //= "";

    opendir(my $dh, $dir) or return;
    
    # Filter out '.', '..', and anything named '.git'
    my @files = sort grep { $_ !~ /^\.\.?$/ && $_ ne '.git' } readdir($dh);
    closedir($dh);

    for my $index (0 .. $#files) {
        my $file    = $files[$index];
        my $is_last = ($index == $#files);
        my $pointer = $is_last ? "└── " : "├── ";
        
        say $prefix . $pointer . $file;

        my $path = "$dir/$file";
        if (-d $path && !-l $path) {
            my $next_prefix = $prefix . ($is_last ? "    " : "│   ");
            print_tree($path, $next_prefix);
        }
    }
}

say ".";
print_tree(".");
