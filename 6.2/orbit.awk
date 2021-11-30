BEGIN { FS=")" }
{ a[$1] != "" ? a[$1] = a[$1] "," $2 : a[$1] = $2 }
END {
    tail("COM", "COM", "YOU")
    you_length = split(r, y, ",")
    tail("COM", "COM", "SAN")
    san_length = split(r, s, ",")
    while(y[++x] == s[x]) { continue }
    print you_length - x + san_length - x
}
function tail(b,path,d,     n,x,t) {
    t=split(a[b],n,",")
    for(x=1;x<=t;x++) {n[x]==d ? r=path","d : tail(n[x],path","n[x],d)}
}
