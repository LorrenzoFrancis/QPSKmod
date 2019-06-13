clc;            % clear screen
clear;          % clear memory
close all;      % closes all other windows


prompt = {'Enter bit sequence below (max 52 bits):'}; % prompt for user
ititle = 'Input'; % title of dialog box
dims = [1 50]; % dimensions of dialog box
temp1 = inputdlg(prompt,ititle,dims); % takes in user input

if rem(length(temp1{1}),2) ~= 0 % checks the number of bits
    
    (msgbox('Odd number of bits entered. Please enter an even number of bits','Error','error')); % error message if an odd number of bits in entered
    
else

temp2 = bin2dec(temp1{1}); %converts user input from binary  to decimal
bit_sequence = str2num(dec2bin(temp2,length(temp1{1})).'); %converts decimal to a binary string array then to number array


data_NRZ = 2 * bit_sequence - 1; % data represented at non-return-to zero form for QPSK modulation
s_p_data = reshape(data_NRZ,2,length(bit_sequence)/2);    % S/P conversion of data

bit_rate = 10^6;                % fixed bit rate
f = bit_rate;                   % for QPSK bit rate is minimum carrier frequency
T = 1/f;                        % bit duration 
t = T/99:T/99:T;                % one bit information time vector

%%%%%%%%%%%%%%%%%%%%%%   CODE FOR QPSK  MODULATION    %%%%%%%%%%%%%

y = []; % vector for transmitted signal
inphase_y_value = []; % vector of inphase signal (cosine wave)
quadrature_y_value = []; %vector for quadrature signal (sine wave)

for i=1:length(bit_sequence)/2
    inphase_component = s_p_data(1,i)*cos(2*pi*f*t);
    quadrature_component = s_p_data(2,i)*sin(2*pi*f*t);
    inphase_y_value = [inphase_y_value  inphase_component];         % inphase signal vector
    quadrature_y_value =[quadrature_y_value quadrature_component];  % quadrature signal vector
    y = [y inphase_component + quadrature_component];   % modulated signal vector
end

Transmitted_signal = y; % transmitting signal after modulation

tt = T/99:T/99:(T*length(bit_sequence))/2; 

figure(1)       % graphs

subplot(2,1,1);
stem(bit_sequence,'linewidth',3,'Color',[.31 .50 .79]), grid on;
title('Data Before Modulation');
xlabel('bit sequence');
ylabel(' value');
axis([0 length(temp1{1})+1 0 1.5]);     %x axis range is from 0 to 1 + number of bits and the y axis range is from 0 to 1.5

subplot(2,1,2);
plot(tt,Transmitted_signal,'linewidth',3,'Color',[.95 .50 .20]), grid on;
title('QPSK modulated signal');
xlabel('time(s)');
ylabel(' amplitude(V)');
end
    
