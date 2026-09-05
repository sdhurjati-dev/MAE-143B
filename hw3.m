close all;
clear;
clc;

% MAE 143B Homework 3
% Sreenidh Dhurjati

d=0.1;
a=1;

%% Question 4
G=RR_pade(d,2,2)*RR_tf(1,[1 a]);
D=1;
L=G*D;

figure(1)
RR_rlocus(G*D)

omega=16.4562;

figure(2)
D=real(RR_evaluate(-1/L,1i*omega))
RR_rlocus(G*D)

%% Question 5
G=RR_pade(d,16,12)*RR_tf(1,[1 a]);
D=1;
L=G*D;

figure(3)
RR_rlocus(G*D)

omega=16.32;
D=real(RR_evaluate(-1/L,1i*omega))

disp('Save Q4 and Q5 figures then press Enter')
pause

%% Question 6 - half of critical K
close all;

d=0.1;
a=1;

G=RR_pade(d,2,2)*RR_tf(1,[1 a]);
g.R=100;

K=8.25;
L=G*K;

RR_nyquist(L,g)

disp('Save the K=8.25 Nyquist plot then press Enter')
pause

%% Question 6 - twice the critical K
close all;

d=0.1;
a=1;

G=RR_pade(d,2,2)*RR_tf(1,[1 a]);
g.R=100;

K=32.98;
L=G*K;

RR_nyquist(L,g)