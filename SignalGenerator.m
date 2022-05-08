Fs = input('Sampling frequency of signal : ');
Start = input('Start time scale : ');
End = input('End of time scale : ');
breakpoints = input('Number of the break points : ');
temp = zeros(1,breakpoints);
z = [Start temp End];
Ttol = linspace(Start,End,Fs*(End-Start));
TolSignal = [];
for i=2:breakpoints+1
   fprintf('Position of break point number %d : ',i-1); 
   z(i)=input('');
   while z(i) >= End  || z(i) <= Start
   fprintf('Please enter the position of break point number %d between [%d %d] : ',i-1,Start,End); 
   z(i)=input('');
    end
end
z=sort(z);
for k=1:breakpoints+1
    limits = z(k+1)-z(k);
    t = linspace(z(k),z(k+1),Fs*limits);
    fprintf('What is the Signal type in region from %d to %d ?',z(k),z(k+1));
    fprintf('\n1)Dc Signal\n2)Ramp Signal\n3)General order polynomial\n4)Exponential signal\n5)Sinusoidal signal\n');
    str = input(' ');
    while str > 5  || str < 1
   fprintf('Please choose a correct Signal number between 1 and 5 in region [%d %d] :',z(k),z(k+1)); 
   str=input(' ');
    end
    if str == 1
        AmpDC = input('Amplitude = ');
        Signal = AmpDC * ones(1,int16(limits*Fs));
        TolSignal=[TolSignal Signal];
    elseif str == 2
        slope = input('Slope = ');
        InterceptR = input ('Intercept = ');
        Signal = slope*t+InterceptR;
        TolSignal=[TolSignal Signal];
    elseif str == 3
        Order = input('Order of this signal : ');
        temp1=Order;
        coeff=[];
        for v=1:Order
        fprintf('Amplitude of power %d (Coefficient) = ',temp1);
        coeff(end+1)=input(' ');
        temp1=temp1-1;
        end
        fprintf('Amplitude of power %d (intercept) = ',temp1);
        coeff(end+1)=input(' ');
        Signal=polyval(coeff,t);
        TolSignal=[TolSignal Signal];
    elseif str == 4
        AmpExp = input ('Amplitude = ');
        Exponent = input ('exponent = ');
        Signal = AmpExp*exp(Exponent*t);
        TolSignal=[TolSignal Signal];
    elseif str == 5
        type=input('Choose the type ?\n1)Sine wave\n2)Cosine wave\n');
        while type < 1 || type > 2 
            type=input('Please Choose the 1 (Sine) or 2 (Cosine) : ');
        end
        AmpSin = input ('Amplitude = ');
        Frequency = input ('Frequency = ');
        W=2*pi*Frequency;
        Phase = input ('Phase in radian = ');
        switch type
            case 1
               Signal = AmpSin*sin(W*t+Phase);
               TolSignal=[TolSignal Signal];
            case 2
               Signal = AmpSin*cos(W*t+Phase);
               TolSignal=[TolSignal Signal];
        end
    end
end
figure;plot (Ttol,TolSignal);title('Orginal Signal');
modify = 0;
op = 0;
while op ~=6
if modify == 0
fprintf('Which operation do you want to preform on the signal?\n');
elseif modify ~= 0
fprintf('Do you want to preform another operation on the signal?\n');
end
fprintf('1)Amplitude Scaling\n2)Time Reversal\n3)Time Shift\n4)Expanding the Signal\n5)Compressing the Signal\n6)None\n');
op = input(' ');
  while op > 6  || op < 1
   fprintf('Please choose a correct operation number between 1 and 6 : '); 
   op=input(' ');
    end
if op == 1 
    Scale=input('Scale Value = ');
    TolSignal=Scale.*TolSignal;
elseif op == 2
    Ttol=Ttol.*-1;
elseif op == 3
    Shift=input('Shift Value = ');
    Ttol=Ttol-Shift;
elseif op == 4
    Expand=input('Expand Value = ');
     Ttol=Ttol.*Expand;
elseif op == 5
    Compress=input('Compression Value = ');
    Ttol=Ttol./Compress;
elseif op == 6
    break
end
fprintf('=> Operation Done Successfully <=\n');
figure;plot (Ttol,TolSignal);title('After The Operation');
modify = modify +1 ;
end
if modify ~=0
    figure;plot (Ttol,TolSignal);title('After All Operations Are Done');
else
    figure;plot (Ttol,TolSignal);title('No Operations Done');
end
    