function verify_cyclic_prefix(txSignal, ofdmSignal, cpLength)
% VERIFY_CYCLIC_PREFIX
% Verifies that the cyclic prefix is correctly copied

disp('First 5 samples of Cyclic Prefix:')
disp(txSignal(1,1:5))

disp('First 5 samples copied from end of OFDM Symbol:')
disp(ofdmSignal(1,end-cpLength+1:end-cpLength+5))

if isequal(txSignal(1,1:cpLength), ...
           ofdmSignal(1,end-cpLength+1:end))

    disp('✓ Cyclic Prefix Verification Successful')

else

    disp('✗ Cyclic Prefix Verification Failed')

end

end