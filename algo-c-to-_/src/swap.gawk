#
#	from src/swap.c
#
#	void swap(int *, int *)		to	swap; in _helper.awk
#	void swap1(int *, int *)	to	swap1
#	void swap2(int *, int *)	to	swap2
#

#
#	swap(a, x, y) from _helper.awk
#

#	only gawk; only Integer
function swap1(a, x, y) {
	a[y]=xor(a[y],a[x]); a[x]=xor(a[x],a[y]); a[y]=xor(a[y],a[x])
}

function swap2(a, x, y) {
	a[y]=a[x]-a[y]; a[x]-=a[y]; a[y]+=a[x]
}
