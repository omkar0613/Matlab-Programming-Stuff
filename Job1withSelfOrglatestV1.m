%% Throughput Calculation for n number of jobs over a network considering same arrival time, service start time and service end time for all jobs
arrivalTimeforAllJobs=[];
fileSizeforAllJobs=[];
startServiceTimeforAllJobs=[];
endServiceTimeforAllJobs=[];
prompt = 'Enter the total number of nodes in the network : ';
N = input(prompt);
prompt='Enter the number of jobs in a network : ';
J=input(prompt);
admissionControlUnitDuration=3600;
capacityMatrix=zeros(N,N);
Ai     =0;                                                                  % In this example, I have considered arrival time, Service start time and service end time same for every job in the network
Si     =0;             
Ei     =3600;   
nextloopcounter=0;                                                          % Counter used to keep the track of job number 

for i=1:J
   fprintf('Enter 6 tuple parameter information for job %d \n',i);
   fprintf('Given arrival time for job %d is : %d \n',i,Ai);
   arrivalTimeforAllJobs(i)=Ai;                                             % Arrival time of Every Job is stored in a matrix
   fprintf('Given Service Start Time for job %d is : %d \n',i,Si);
   startServiceTimeforAllJobs(i)=Si;                                        % Service Start time of Every Job is stored in a matrix
   fprintf('Given Service End Time for job %d is : %d \n',i,Ei);
   endServiceTimeforAllJobs(i)=Ei;                                          % Service End time of Every Job is stored in a matrix
   fprintf('Network has total %d nodes numbered from 1 to %d. Choose Source and Destination Nodes accordingly.\n',N,N);
   prompt='What is a source node for job ?';
   si=input(prompt);                                                        % Source Node is obtained from user for every job
   prompt='What is a destination node for job ? : ';
   di=input(prompt);                                                        % Destination Node is obtained from user for every job
   prompt='What is the size of a file you want to transfer ? : ';
   Di=input(prompt);
   fileSizeforAllJobs(i)=Di;                                                % User enters the file size for a job
   fprintf ('6-tuple information for job %d is [ %d , %d , %d , %d , %d , %d ]\n \n',i,Ai,si,di,Di,Si,Ei);
   orgDistanceMatrix=Inf(N,N);
   distanceMatrix=Inf(N,N);
   distanceMatrix(1,2)=50;                                                  % The given distance between a pair of node 
   distanceMatrix(1,11)=100;
   distanceMatrix(2,3)=40;
   distanceMatrix(2,7)=140;
   distanceMatrix(2,10)=190;
   distanceMatrix(3,4)=60;
   distanceMatrix(4,5)=100;
   distanceMatrix(5,6)=50;
   distanceMatrix(6,7)=70;
   distanceMatrix(7,8)=70;
   distanceMatrix(8,9)=40;
   distanceMatrix(9,10)=50;
   distanceMatrix(10,11)=120;
   distanceMatrix(1,12)=70; 
   distanceMatrix(10,12)=50;
   distanceMatrix(11,12)=40; 
   distanceMatrix(2,13)=60; 
   distanceMatrix(7,13)=50; 
   distanceMatrix(9,13)=30; 
   distanceMatrix(2,5)=80;
   dikstraHop=zeros(N,N);                                                   % This Matrix is used to create a row of Djikstra's Algorithm. Index of every row will give the next node in a sequence
   temporaryMatrix=zeros(1,N);                                              % To obtain the minimum weight during every hop, most recent Djikstra Row (Every Element) will be compared 
                                                                            % with the distances, source node will have with every other node. The minimum of two will be selected 
   getValue=[];                                                             % Minimum value from the row of temporaryMatrix will be saved in getValue[]
   position=[];                                                             % This will be the position of the minimum weight value in temporaryMatrix. This position value will be my next node to be considered 
%   optimalPathsforAllJobs={};
   nodeSequence=zeros(1,N);                                                 % Node sequence Matrix will give me the next node, where I get minimmum weight with Djikstra's Implementation
                                                                
   optimalPath=[];
      for l=1:N
         for k=1:N
            if l==k
             distanceMatrix(l,k)=0;
            end
             distanceMatrix(k,l)=distanceMatrix(l,k);                       % (N*N) distance Matrix generation
         end
      end
orgDistanceMatrix=distanceMatrix; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Djikstra Algorithm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
columnCountforEqualWeights=1;                                               % This counter is used in case of Tie in Djikstra row. One of the position will be selected initially and the remaining position will be selected later
nodecount=1;                                                                % Basic Counter used in Djikstra's Algorithm to consider all nodes
%count=0;
A=zeros(1,N);                                                               % To use min function, A is used which stores the matrix dikstraHop(nodecount,:) which is a row which has to be considered for minimum weight
    while nodecount<=N   %% to be changed to N
      nodeSequence(1,nodecount)=si;                                         % The given source node is stored as a first value in nodeSequence Matrix
         if nodecount==1
           dikstraHop(nodecount,:)=distanceMatrix(si,:);                    % IF while loop is executed for first time, it will just copy the minimum weight row from distance matrix to dikstraHop matrix.
         else
           temporaryMatrix=distanceMatrix(si,:);                            % Else, it will create a temporary matrix of size (1,N).For this condition we need to compare the values and then decide the minimum weight
           [row,columnNumber]=find(temporaryMatrix > 0 & temporaryMatrix < Inf); % We obtain positions of all non-zero values from a row. These positions are basically the nodes which are directly connected by link
                                                                                 % to the source node for this hop.
           dikstraHop(nodecount,:)=dikstraHop(nodecount-1,:) ;              % Next Row in Djikstra Matrix will be copied as previous row is.
              for i=1:size(columnNumber,2)
                getValue(i)=temporaryMatrix(columnNumber(i));               % All non-zero values from the row are stored in a matrix.
                   if minCap+getValue(i) < dikstraHop(nodecount-1,columnNumber(i))   % If a new minimum weight is generated, we will update the value in a row with this new minimum weight
                         dikstraHop(nodecount,columnNumber(i))=minCap+getValue(i);
                   end
              end
         end
           if nodecount==N                                                  % If all N nodes in a network are considered, then we will make value of si equal to the actual source for the job.
               si=nodeSequence(1,1);
               break                                                        % As Algorithm is run for all nodes, loop will be terminated
           end
           if size(position,2)>1 && columnCountforEqualWeights<size(position,2) % IF we get a Tie in a row during algorithm implementation, we will consider the value with lower column and eventually will add the counter
                                                                                % and will consider all locations with that same value.
               minCap=dikstraHop(nodecount-1,position(1,columnCountforEqualWeights));
               columnCountforEqualWeights=columnCountforEqualWeights+1;
           else
               position=[];                                                 % If size of position matrix is not greater than 2, then first, we will make it empty
               columnCountforEqualWeights=1;
               A=dikstraHop(nodecount,:);
               minCap= min(A(A>dikstraHop(nodecount,si)));                  % Finding out the minimum weight from Djikstra Matrix
           end
               position=find(dikstraHop(nodecount,:)==minCap);              % Finding out the position of the minimum weight in a row
    
               if size(position,2)>1 && columnCountforEqualWeights<=size(position,2)
                    distanceMatrix(position(1,columnCountforEqualWeights),si)=0; % In case of a tie, this will be executed when we have to consider same minimum weight value n number of times.
                    si=position(1,columnCountforEqualWeights);
               else
                    distanceMatrix(position,si)=0;                          % This position is made 0 because, we dont need to to consider thi position for a minimum value.                                                 
                    si=position;                                            % New Source Node for next hop will be obtained from position Matrix.
               end 
                    nodecount=nodecount+1;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
countofNodes=1;
   while (di ~= si)                                                         % At this line, Djikstra Algorithm is implemented and we have whole matrix
        nextHop= dikstraHop(:,di);
        for minValuePosition=1:N
              if nextHop(minValuePosition)==min(dikstraHop(:,di))           % minValuePosition will give me the next node in optimal path (Based on the generated matrix).
                 break
              end
        end
        optimalPath(countofNodes)=di;                                       % Every node considered is stored in a matrix
              if(di==si)
                  break                                                     % If Destination Node and Source Node is same, the loop will be terminated
              end
        di=nodeSequence(minValuePosition);                                  % Next node will be obtained from minValuePosition
        countofNodes=countofNodes+1;
   end
        optimalPath=fliplr(optimalPath);                                    % Flipping the matrix and concatenating the first node (source node) will generate the optimal path
        optimalPath=horzcat(si,optimalPath);
        fprintf('Optimal Path for Job %d is : ',i);
        display (optimalPath);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        optimalPathsforAllJobs{i}=optimalPath;
        S      =50;             % Radiated Power at the Transmitter
        W      =10^(8);         % Bandwidth
        No     =10^(-12);       % Noise Spectral Density
        numberOfSlices=((Ei-Si)/admissionControlUnitDuration);
        lengthOfTimeSlices=admissionControlUnitDuration;
              for l=1:N
                  for k=1:N
                          capacityMatrix(l,k)=(W/N)*log2(1+((S*(orgDistanceMatrix(l,k)^(-2.5)))/(No*(W/N))));        % Capacity Mtrix obtained from given distance matrix
                  end
              end
              maxData=0;
                     for ii=1:((size(optimalPath,2))-1)
                          maxData=maxData+((capacityMatrix(optimalPath(ii),optimalPath(ii+1)))*lengthOfTimeSlices); % Maximum amount of data that can flow through a optimal path is obtained
                     end
         optimizedThroughput=maxData/((size(optimalPath,2)-1)*Di);                                    % Ratio of the Maximum data transfer to the actual job size gives the throughput for the job, number of hops are considered
         throughputBasedOnNodalDistance=(1/optimizedThroughput);            % This is to show that, if two nodes are near to eachother, then file will be transferred with more throughput
         fprintf('Optimal Throughput for job %d is : ',i);
%         display(throughputBasedOnNodalDistance);
         display(optimizedThroughput);
         fprintf('\n');
         fprintf('\n');
         distanceBetweenNodes=0;
                     for dist=1:((size(optimalPath,2))-1)
                         distanceBetweenNodes = distanceBetweenNodes+orgDistanceMatrix(optimalPath(dist),optimalPath(dist+1)); % Maximum amount of data that can flow through a optimal path is obtained
                     end
                     display(distanceBetweenNodes);
                     
                     
                    stem(distanceBetweenNodes,optimizedThroughput,'.'); hold on
         nextloopcounter=nextloopcounter+1;
              if (nextloopcounter < J)
                       prompt='Do you want to continue for next job ? If Yes then press Y else press N ';
                       str = input(prompt,'s');   
                            if str=='Y' || str=='y'
                               continue
                            elseif str=='N' || str=='n'
                               break
                            else
                               fprintf('Wrong Input');
                            end
              else
                       break 
              end

end
title('Throughput Calculation for the list of Jobs');
xlabel('Total Distance from Source Node to Destination Node for every Job');
ylabel('Optimal Throughput for every Job in the Network');