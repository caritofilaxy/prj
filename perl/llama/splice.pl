#!/usr/bin/perl
#

# Remove to @extracted qw(three four five)
@nums = qw(one two three four five);
@extracted = splice(@nums,2);
print "$_ "for @nums;
print "\n";

# Remove to @extracted qw(three)
@nums = qw(one two three four five);
@extracted = splice(@nums,2,1);
print "$_ "for @nums;
print "\n";

# remove to @extracted and replace qw(three) to qw(six)
@nums = qw(one two three four five);
@extracted = splice(@nums,2,1,qw(six));
print "$_ "for @nums;
print "\n";

#insert to @nums
@nums = qw(one two three four five);
@extracted = splice(@nums,2,0,qw(six));
print "$_ "for @nums;
print "\n";
