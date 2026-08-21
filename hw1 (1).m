% MAE 143B Homework 1
% Sreenidh Dhurjati

%% Question 1
s = tf('s');
Dlead = (s + 2.68)/(s + 37.32);
bode(Dlead); grid on

%% Question 2a

% lag compensator
p = 0.00884;
z = 0.884;

Dlag = tf([1 z],[1 p]);

bode(Dlag)
grid on
title('Bode Plot of Lag Compensator')

%% Question 2b

p1 = 0.00884;
z1 = 0.884;

Dlag = tf([1 z1],[1 p1]);

% double lag values
p2 = 0.0485;
z2 = 0.485;

Ddoublelag = tf([1 z2],[1 p2])^2;

bode(Dlag)
hold on
bode(Ddoublelag)
grid on

legend('Single Lag','Double Lag')
title('Bode Plot of Lag Compensators')

%% Question 3a
wc = 299.5;

D1 = tf(wc^2,[1 0.76537*wc wc^2]);
D2 = tf(wc^2,[1 1.84776*wc wc^2]);

Dbutter = D1*D2;

bode(Dbutter)
grid on
title('4th Order Butterworth Low-Pass Filter')

%% Question 3b
s = tf('s');

% Butterworth filter
wc1 = 299.5;

D1 = tf(wc1^2,[1 0.76537*wc1 wc1^2]);
D2 = tf(wc1^2,[1 1.84776*wc1 wc1^2]);

Dbutter = D1*D2;

% inverse Chebyshev filter
wc2 = 979;
x = s/wc2;

Dinv = 0.001*((x^2 + 1.17157)*(x^2 + 6.82843)) / ...
    ((x^2 + 0.21682*x + 0.086659)* ...
    (x^2 + 0.55761*x + 0.092316));

bode(Dbutter)
hold on
bode(Dinv)
grid on

legend('Butterworth','Inverse Chebyshev')
title('4th Order Low-Pass Filters')

%% Question 4b
s = tf('s');

% lead 
Dlead = (s + 2.68)/(s + 37.32);

% double lag
Dlag = ((s + 0.485)/(s + 0.0485))^2;

% inverse Chebyshev
wc = 979;
x = s/wc;

Dinv = 0.001*((x^2 + 1.17157)*(x^2 + 6.82843)) / ((x^2 + 0.21682*x + 0.086659)* (x^2 + 0.55761*x + 0.092316));

% combined controller leaving K out 
D = Dlead*Dlag*Dinv;

% Tustin with prewarping
h = 0.001;
wg = 10;

opt = c2dOptions('Method','tustin','PrewarpFrequency',wg);
Dz = c2d(D,h,opt);

% get coefficients
[b,a] = tfdata(Dz,'v');

a
b

%% Question 5b

s = tf('s');

G = 100/(s^2 - 100);

Dsimple0 = (s + 10)/(s + 20);
Ksimple = 3;
Dsimple = Ksimple*Dsimple0;

Dlead = (s + 2.68)/(s + 37.32);

Dlag = ((s + 0.485)/(s + 0.0485))^2;

wc = 979;
x = s/wc;

Dinv = 0.001*((x^2 + 1.17157)*(x^2 + 6.82843)) / ((x^2 + 0.21682*x + 0.086659)* (x^2 + 0.55761*x + 0.092316));

D0 = Dlead*Dlag*Dinv;

wg = 10;

[mag,phase] = bode(G*D0,wg);
mag = squeeze(mag);

K = 1/mag

Dloop = K*D0;

figure
subplot(1,2,1)
rlocus(G*Dsimple0)
grid on
title('Root Locus - Simple Lead')

subplot(1,2,2)
rlocus(G*D0)
grid on
title('Root Locus - Loop Shaping')

figure
bode(G*Dsimple,G*Dloop)
grid on
legend('Simple Lead','Loop Shaping')
title('Open-Loop Bode Plots')

Tsimple = feedback(G*Dsimple,1);
Tloop = feedback(G*Dloop,1);

figure
subplot(2,1,1)
step(Tsimple)
grid on
title('Closed-Loop Step Response - Simple Lead')

subplot(2,1,2)
step(Tloop)
grid on
title('Closed-Loop Step Response - Loop Shaping')

disp('Simple lead closed-loop poles:')
pole(Tsimple)

disp('Loop shaping closed-loop poles:')
pole(Tloop)

disp('Simple lead step info:')
stepinfo(Tsimple)

disp('Loop shaping step info:')
stepinfo(Tloop)