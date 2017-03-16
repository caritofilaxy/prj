#!/usr/bin/perl
#

# Remove to @extracted qw(three four five)
@nums = qw(one two three four five);
@extracted = splice(@nums,2);
print "@nums\n";

# Remove to @extracted qw(three)
@nums = qw(one two three four five);
@extracted = splice(@nums,2,1);
print "@nums\n";

# remove to @extracted and replace qw(three) to qw(six)
@nums = qw(one two three four five);
@extracted = splice(@nums,2,1,qw(six));
print "@nums\n";

#insert to @nums
@nums = qw(one two three four five);
@extracted = splice(@nums,2,0,qw(six));
print "@nums\n";
