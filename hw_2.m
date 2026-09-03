close all;
clear;
clc;

% MAE 143B Homework 2
% Sreenidh Dhurjati

%% Given values
d = 12;
a0 = 0.02;
g.T = 200;

% F2,2 Pade approximation for delay
F22 = RR_pade(d,2,2);

% Plant
G = F22*RR_tf(1,[1/a0 1]);


%% Part 1: D=1

D = 1;
P = 2;

% figure(1)
% RR_rlocus(G)
% axis([-.4 .3 -.3 .3])
% title('Root Locus, D(s)=1') 

figure(2)
RR_step(35 + 10*P*G*D/(1+G*D),g)
axis([0 200 32 55])
title('Output y(t) with D=1')

figure(3)
RR_step(35 + 10*P*D/(1+G*D),g)
axis([0 200 40 60])
title('Control Input u(t) with D=1')

% y(t) looks fine but u(t) shoots past 50 deg limit
% actuator is gonna saturate


%% Part 2: P Control


% K = 0.5; % still barely over 50
% K = 0.49; % 50.1 still too high
K = 0.488; % just under 50
D = RR_tf(K);

% adjust P for correct steady-state (G(0)=1)
P = (1 + K)/K % left unsuppressed to check value in command window

figure(4)
RR_rlocus(G,D)
axis([-.4 .3 -.3 .3])
title('RL with P Control')


% Output response
figure(5)
[t,~,y] = RR_plot_response(35 + 10*P*G*D/(1+G*D),0,g);
grid on
hold on
axis([0 200 34 55])
title('P-Control Output')

yline(45,'k')
yline(45.5,'--r')
yline(44.5,'--r')

% finding settling time
outside = find(abs(y-45) >= 0.5);
if isempty(outside)
    t_settle_P = 0;
elseif outside(end) < length(t)
    t_settle_P = t(outside(end)+1);
else
    t_settle_P = NaN;
end

t_settle_P % prints to console

if ~isnan(t_settle_P)
    xline(t_settle_P,'--', ['ts = ' num2str(t_settle_P) ' s'])
end
hold off


% Control input
figure(6)
[~,~,u] = RR_plot_response(35 + 10*P*D/(1+G*D),0,g);
grid on
hold on
axis([0 200 40 60])
title('P-Control Input')

max_u_P = max(u)

yline(50,'--r')
yline(max_u_P,'--', ['Max u = ' num2str(max_u_P)])
hold off

% this keeps it under 50 but settling time is painfully slow (~99s)


%% Part 3: Lead/Lag Controller

% tuned by trial and error to speed it up while keeping u < 50
% K = 0.5; z = 0.08; p = 0.04; % too aggressive

K = 0.47;
z = 0.1;
p = 0.05;

D = RR_tf(K*[1 z],[1 p]);

figure(7)
RR_rlocus(G,D)
axis([-.4 .3 -.3 .3])
title('RL with Final Controller')

% calculated from formula
P = 2.063909364853201; 


%% Final output response (F2,2)

figure(8)
[t,~,y] = RR_plot_response(35 + 10*P*G*D/(1+G*D),0,g);
grid on
hold on
axis([0 200 34 55])
title('Final Controller Output')

yline(45,'k')
yline(45.5,'--r')
yline(44.5,'--r')

outside = find(abs(y-45) >= 0.5);
if isempty(outside)
    t_settle = 0;
elseif outside(end) < length(t)
    t_settle = t(outside(end)+1);
else
    t_settle = NaN;
end

t_settle 

if ~isnan(t_settle)
    xline(t_settle,'--', ['ts = ' num2str(t_settle) ' s'])
end
hold off


%% Final control input (F2,2)

figure(9)
[~,~,u] = RR_plot_response(35 + 10*P*D/(1+G*D),0,g);
grid on
hold on
axis([0 200 40 60])
title('Final Controller Input')

max_u = max(u)
min_u = min(u)

yline(50,'--r')
yline(10,'--r')
yline(max_u,'--', ['Max u = ' num2str(max_u)])
hold off


%% Double check everything with higher order F16,13

F_16_13 = RR_pade(d,16,13);
G_high = F_16_13*RR_tf(1,[1/a0 1]);

% figure(10)
% RR_rlocus(G_high,D)
% title('RL with F16,13')

%% F16,13 output check

figure(11)
[t_high,~,y_high] = RR_plot_response(35 + 10*P*G_high*D/(1+G_high*D),0,g);
grid on
hold on
axis([0 200 34 55])
title('Check Output (F16,13)')

yline(45,'k')
yline(45.5,'--r')
yline(44.5,'--r')

outside_high = find(abs(y_high-45) >= 0.5);
if isempty(outside_high)
    t_settle_high = 0;
elseif outside_high(end) < length(t_high)
    t_settle_high = t_high(outside_high(end)+1);
else
    t_settle_high = NaN;
end

t_settle_high

if ~isnan(t_settle_high)
    xline(t_settle_high,'--', ['ts = ' num2str(t_settle_high) ' s'])
end
hold off


%% F16,13 input check

figure(12)
[~,~,u_high] = RR_plot_response(35 + 10*P*D/(1+G_high*D),0,g);
grid on
hold on
axis([0 200 40 60])
title('Check Input (F16,13)')

max_u_high = max(u_high)
% min_u_high = min(u_high) % don't really care about the min

yline(50,'--r')
yline(10,'--r')
yline(max_u_high,'--', ['Max u = ' num2str(max_u_high)])
hold off