{ x[NR] = $2**(1./3.); y[NR] = log($5);
    sx += x[NR]; sy += y[NR]; 
    sxx += x[NR]*x[NR];
    sxy += x[NR]*y[NR];
}

END{
    det = NR*sxx - sx*sx;
    a = (NR*sxy - sx*sy)/det;
    b = (-sx*sxy+sxx*sy)/det;
    print a;
# for(i=1;i<=NR;i++) print x[i],a*x[i]+b;
}
