#
#	from src/swap.c
#
#	void swap(int *, int *)		to	swap; in _helper.awk
#	(void swap1(int *, int *)	to	swap1)
#	void swap2(int *, int *)	to	swap2
#

#
#	swap(a, x, y) from _helper.awk
#

# see http://www.intex.tokyo/unix/awk-02.html
#function _xor(x, y,	...) {
#	...
#}
#
#function swap1(a, x, y) {
#	a[y]=_xor(a[y],a[x]); a[x]=_xor(a[x],a[y]); a[y]=_xor(a[y],a[x])
#}

# in GAWK
#
# 9.1.6 Bit-Manipulation Functions
# https://www.gnu.org/software/gawk/manual/html_node/Bitwise-Functions.html
#
#function swap1(a, x, y) {
#	a[y]=xor(a[y],a[x]); a[x]=xor(a[x],a[y]); a[y]=xor(a[y],a[x])
#}

function swap2(a, x, y) {
	a[y]=a[x]-a[y]; a[x]-=a[y]; a[y]+=a[x]
}
