% Digital PAM with AWGN Channel
% Probability of Error Simulation

clear; clc;

% Simulation Parameters
Nsym = 1e6; % Number of symbols
M = 4; % Number of amplitude levels
SNRdB = linspace(0, 15, 16); % SNR in dB
SNR = 10.^(SNRdB/10); % SNR in linear scale

% Generate Random Symbols
x = randi([0, M-1], Nsym, 1);

% PAM Modulation
x_pam = 2*x - M + 1;

% AWGN Channel
noise = randn(Nsym, length(SNR));
y_pam = sqrt(SNR).*x_pam + noise;

% PAM Demodulation
y = y_pam./sqrt(SNR);
y_hat = round((y + M - 1)./2);

% Probability of Error Calculation
Pe = zeros(1, length(SNR)); % Initialize Pe variable
for ii = 1:length(SNR)
    err = sum(x ~= y_hat(:, ii));
    Pe(ii) = err/Nsym;
end

% Theoretical Probability of Error Calculation
Pe_theory = 2*(M-1)/M*qfunc(sqrt(3/2*SNR*log2(M)/(M^2-1)));

% Plot Probability of Error
semilogy(SNRdB, Pe, 'bo-', 'LineWidth', 2);
hold on;
semilogy(SNRdB, Pe_theory, 'r.-', 'LineWidth', 2);
grid on;
xlabel('SNR (dB)');
ylabel('Probability of Error');
legend('Simulation', 'Theory');
