%%%% Electrical Vehicle Range Estimation using MATLAB based on FTP-75 Drive
%%%% Cycle


data = readmatrix('FTP75.txt');

time = data(:,1);

speed_mph = data(:,2);

speed_mps = speed_mph*0.44704;

drive_cycle_input = [time , speed_mps];                              % Simulink data

%% plot Speed Vs Time %%

plot(time,speed_mps);
xlabel('Time (s)');
ylabel('Speed (m/s)');
title('FTP-75 Drive Cycle');
grid on;

%%%% Acceleration computation %%%% 

dt = diff(time);
dv = diff(speed_mps);

acceleration = dv ./ dt;

time_acc = time(2:end);

Acceleration_N = [time_acc,diff(speed_mps)./diff(time)];            % Simulink data


%% plot Acceleration Vs Time %%

figure;
plot(time_acc,acceleration,'r','LineWidth',1.5);
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
title('Acceleration Vs Time');
grid on;


%%%% Vehicle parameter %%%%

m = 1200;                                                           % Mass of vehicle in kg
g = 9.81;                                                           % Gravity
Cr = 0.015;                                                         % Rolling resistance coefficient
rho = 1.225;                                                        % Air density in kg/m^2
A = 2.2;                                                            % Frontal area in m^2
Cd = 0.29;                                                          % Drag coefficient

%%%% Force Calculation %%%%

F_inertia = m .* acceleration;
F_roll = m * g * Cr * ones(size(time_acc));
F_drag = 0.5 * rho * A * Cd .* (speed_mps(2:end)).^2;

F_total = F_inertia + F_roll + F_drag;

%% plot Force Vs Time %%

figure;
plot(time_acc , F_total);
xlabel('Time (s)');
ylabel('Total Force (N)');
title('Total Force Vs Time'); 
grid on;


%%%% Power calculation %%%%

Power = F_total .* speed_mps(2:end);

%% Plot Power Vs Time %%

figure;
plot(time_acc , Power);
xlabel('Time (S)')
ylabel('Power (W)')
title('Power Vs Time')
grid on;


%%%% Distance calculation %%%%

distance_m = trapz(time , speed_mps);

distance_km = distance_m/1000;

fprintf('Total distance travelled:%2f km\n' , distance_km); 


%%%% Energy Calculation %%%%

delta_t = 1;                                                         % Each time step is 1 second

power_kw = Power / 1000;                                             % Converts watts to kilowatts

Energy_each_sec = power_kw * (delta_t/3600);                         % Energy in per second in kwh

Total_energy_kwh = sum(Energy_each_sec);

fprintf('Total energy consumed:%.2f kwh\n' , Total_energy_kwh); 


%%%% Range calculation %%%%

battery_capacity_kwh = 35;

EV_Range = (battery_capacity_kwh/Total_energy_kwh) * distance_km;

fprintf('The Range of EV is:%.2f km\n' , EV_Range);

















