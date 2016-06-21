            function GoodPlot(obj)
               xaxisR='Index';
                yaxisR='Re Output';
                ztitleR='Real Output of Discrete LTI Channel';
                 xaxisI='Index';
                yaxisI='Im Output';
                ztitleI='Imag Output of Discrete LTI Channel';   
            
            subplot(2,1,1), plot(real(obj.y));
                xlabel(xaxisR);
                ylabel(yaxisR);
                title(ztitleR);
                subplot(2,1,2), plot(imag(obj.y));
                xlabel(xaxisI);
                ylabel(yaxisI);
                title(ztitleI);

            