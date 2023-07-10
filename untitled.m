% Simulation parameters
M = 2;                      % Number of symbols
k = log2(M);                % Number of bits per symbol
EbNoVec = 0:2:10;           % Eb/No values to simulate
numBits = 1e5;              % Number of bits to simulate
n = 1;                      % Number of samples per symbol

% Pre-allocate arrays for storing results
PE = zeros(size(EbNoVec));  % Probability of Error
SER = zeros(size(EbNoVec)); % Symbol Error Rate

% Transmitter
data = randi([0 1], numBits, 1);           % Random binary data
dataSymbols = bi2de(reshape(data, k, []).' , 'left-msb')';  % Group bits into symbols

for ii = 1:length(EbNoVec)
    % DPAM modulation
    txSig = pammod(dataSymbols, M);

    % Channel
    rxSig = awgn(txSig, EbNoVec(ii) + 10*log10(k) - 10*log10(n), 'measured');

    % Receiver
    rxDataSymbols = pamdemod(rxSig, M);
    rxData = de2bi(rxDataSymbols, k, 'left-msb')'; % Convert symbols to bits
    rxData = rxData(:); % Convert bits to a column vector
    numErrors = sum(data ~= rxData); % Count the number of bit errors
    PE(ii) = numErrors/numBits; % Calculate the Probability of Error (PE)
    SER(ii) = sum(dataSymbols ~= rxDataSymbols)/length(dataSymbols); % Calculate the Symbol Error Rate (SER)
end

% Plot results
figure;
semilogy(EbNoVec, PE, 'bo-');
hold on;
semilogy(EbNoVec, SER, 'rx-');
grid on;
xlabel('Eb/No (dB)');
ylabel('Probability of Error');
legend('PE', 'SER');
title('DPAM Performance Analysis');
