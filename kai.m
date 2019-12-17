ws1=0.3; 
wp1=0.4;
wp2=0.6;
ws2=0.7;
As=40;

ws1=ws1*pi; 
wp1=wp1*pi;
wp2=wp2*pi;
ws2=ws2*pi;
% Caculate M and beta
tr_width = min((wp1-ws1),(ws2-wp2));        % Transition bandwidth
M = ceil((As-7.95)/(14.36*tr_width/(2*pi)));
M = 2*floor(M/2)+1                        % Odd filter length
n=0:1:(M-1);                         
if As >= 50
    beta = 0.1102*(As-8.7)
elseif (As < 50) && (As > 21)
    beta = 0.5842*(As-21)^(0.4) + 0.07886*(As-21)
else
    error('As must be greater than 21')
end


w_kai = (kaiser(M,beta))';                  % Caculate Kaiser window function
wc1 = (ws1+wp1)/2;                          % cutoff freq of ideal LPF 1
wc2 = (wp2+ws2)/2;                          % cutoff freq of ideal LPF 2
hd = ideal_lp(wc2,M) - ideal_lp(wc1,M);     % Caculate the ideal impulse response
h = hd .* w_kai                           % Actual impulse response h(n)
[db,mag,pha,grd,w] = freqz_m(h,1);        % Caculate Magnitude Response
delta_w = 2*pi/1000;                        %
Rp = -min(db(wp1/delta_w+1:1:wp2/delta_w));  % Actua; Passband Ripple
      %
As = -round(max(db(ws2/delta_w+1:1:501))) ;  % Min Stopband Attenuation

%==================================================
% plot Ideal impulse response hd(n)
subplot(1,1,1);
subplot(2,2,1); stem(n,hd,'.'); title('dap ung xung ly tuong  hd(n)')
axis([0 M-1 -0.4 0.4]); xlabel('n'); ylabel('hd(n)')
%==================================================
% plot Kaiser window function w_kai(n)
subplot(2,2,2); stem(n,w_kai,'.');title('Kaiser Window w(n)')
axis([0 M-1 -0.1 1.1]); xlabel('n'); ylabel('w(n)')
%==================================================
% plot design impulse response h(n)
subplot(2,2,3); stem(n,h,'.');title('dap ung xung thuc te h(n)')
axis([0 M-1 -0.4 0.4]); xlabel('n'); ylabel('h(n)')
%==================================================
% plot magnitude response in dB
subplot(2,2,4); plot(w/pi,db);
title('Magnitude Response in dB');grid;
xlabel('frequency in pi units'); ylabel('Decibels')
axis([0 1 -150 10]); 
%==================================================
% plot dash lines
set(gca,'XTickMode','manual','XTick',[0,ws1/pi,wp1/pi,wp2/pi,ws2/pi,1])
set(gca,'YTickMode','manual','YTick',[-As,0])
