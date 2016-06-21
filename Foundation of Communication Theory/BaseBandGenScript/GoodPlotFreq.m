            function GoodPlotFreq(obj, fs, plotnum)
                xaxis='Freq Index';
                yaxis='Output in dB';
                ztitle='Freq Output of Discrete LTI Channel';
               figure(plotnum);
               datafreq=20*log10(abs(fft(obj.y, obj.NFREQ)));
               xdataval=[0:obj.NFREQ-1]*(fs/obj.NFREQ);
               xdataval2=xdataval-fs/2;
               datafreq2=[datafreq(obj.NFREQ/2:end), datafreq(1:obj.NFREQ/2-1)];
              plot(xdataval2, datafreq2);
                xlabel(xaxis);
                ylabel(yaxis);
                title(ztitle);


            