ws1=0.65; 
wp1=0.75;
wp2=0.85;
ws2=0.95;
As=40;

ws1=ws1*pi; 
wp1=wp1*pi;
wp2=wp2*pi;
ws2=ws2*pi;
% Caculate M and beta
tr_width = min((wp1-ws1),(ws2-wp2));        % Transition bandwidth
M = ceil((As-7.95)/(14.36*tr_width/(2*pi))+1)+1;
M = 2*floor(M/2)+1 ;                        % Odd filter length
n=0:1:(M-1);                         
if As >= 50
    beta = 0.1102*(As-8.7);
elseif (As < 50) && (As > 21)
    beta = 0.5842*(As-21)^(0.4) + 0.07886*(As-21);
else
    error('As must be greater than 21')
end


w_kai = (kaiser(M,beta))';                  % Caculate Kaiser window function
wc1 = (ws1+wp1)/2;                          % cutoff freq of ideal LPF 1
wc2 = (wp2+ws2)/2;                          % cutoff freq of ideal LPF 2
hd = ideal_lp(wc2,M) - ideal_lp(wc1,M);     % Caculate the ideal impulse response
h = hd .* w_kai;                            % Actual impulse response h(n)
fs=40000;
ts=1/fs;
ns=512;
t=0:ts:(ts*(ns-1));
x1=sin(2*pi*400000*t);
x2=sin(2*pi*900000*t);
x3=sin(2*pi*1000000*t);
x4=sin(2*pi*1400000*t);
x=x1+x3+x2+x4;
y=conv(x,h);
subplot(2,2,1);
plot(t,x);
k=length(y);
n1=0:1:(k-1);
subplot(2,2,2);
plot(n1,y);
xfft=(abs(fft(x,ns)));
xfftmagh=xfft(1:length(xfft)/2);
f=(1:1:(length(xfftmagh)))*fs/ns;
subplot(2,2,3);
plot(f,xfftmagh);
yfft=(abs(fft(y,ns)));
yfftmagh=yfft(1:length(yfft)/2);
subplot(2,2,4);
plot(f,yfftmagh);


