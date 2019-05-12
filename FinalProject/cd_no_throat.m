clear all; clc; close all;

inlet_d = 25;
choke_d = 1;
outlet_d = 35;

choke_length = 0;
inlet_angle = .27494; 
outlet_angle = .25568;

inlet_length = 27.62528;
outlet_length = 50;

node(1,:) = [0 0 0];
node(2,:) = [inlet_length*cos(inlet_angle) inlet_length*sin(inlet_angle) 0];
node(3,:) = [node(2,1)+outlet_length*cos(outlet_angle) node(2,2)-outlet_length*sin(outlet_angle) 0];

node(4,:) =[node(1,1) node(1,2)+inlet_d 0];  
node(5,:) =[node(2,1) node(2,2)+choke_d 0];
node(6,:) = [node(3,1) node(3,2)+outlet_d 0];
for i=7:12
   node(i,:) = [node(i-6,1:2) .01]; 
end
node(13,:) = [-10 0 0];
node(14,:) = [-10 inlet_d 0];
node(15,:) = [-10 0 .01];
node(16,:) = [-10 inlet_d .01];
node(17,:) = [node(4,1)+10 node(4,2) 0];
node(18,:) = [node(4,1)+10 node(4,2)+outlet_d 0];
node(19,:) = [node(4,1)+10 node(4,2) .01];
node(20,:) = [node(4,1)+10 node(4,2)+outlet_d .01];

blockMeshCreator(node)

function blockMeshCreator(vertices)
    %Create file with write
    FName = 'blockMeshDict';
    FID = fopen(FName, 'w');
    
    %Write Header
    fprintf(FID, '//OpenFOAM blockMeshDict\n');

    fprintf(FID, 'FoamFile\n{\n  version\t2.0;\n  format\tascii;\n  class\t\tdictionary;\n  object\tblockMeshDict;\n}\n\n');
    fprintf(FID, 'convertToMeters 1.0;\n\n');
    
    %Vertices Section
    fprintf(FID, 'vertices\n(\n');
    for i = 1:length(vertices)
        vi = num2str( vertices(i,:) );
        fprintf(FID, strcat('\t(', vi, ')\n') ) ;
    end
    fprintf(FID,'\n);\n\n');
    
    %Block Section
    fprintf(FID, 'blocks\n(\n');
    fprintf(FID, 'hex (0 1 4 3 6 7 10 9) (20 20 1) simpleGrading (1 1 1)\n');
    fprintf(FID, 'hex (1 2 5 4 7 8 11 10) (20 20 1) simpleGrading (1 1 1)\n');
    fprintf(FID, 'hex (12 0 9 15 14 6 9 15) (20 20 1) simpleGrading (1 1 1)\n');
    fprintf(FID, 'hex (2 16 17 5 8 18 19 11) (20 20 1) simpleGrading (1 1 1)\n');
    fprintf(FID, ');\n\n');
    
    % Boundary
    fprintf(FID, 'boundary\n(\n');
    %inlet
    fprintf(FID, '\n \tinlet \n\t{');
    fprintf(FID, '\n \t\ttype patch;\n \t\tfaces\n\t\t(');
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(12 14 15 13)');
    fprintf(FID, '\n\t\t);\n\t}\n'); 
    
    %outlet
    fprintf(FID, '\n \toutlet \n\t{');
    fprintf(FID, '\n \t\ttype patch;\n \t\tfaces\n\t\t(');
    
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(16 18 19 17)');
    fprintf(FID, '\n\t\t);\n\t}\n'); 
    
    %top
    fprintf(FID, '\n \ttop \n\t{');
    fprintf(FID, '\n \t\ttype symmetryPlane;\n \t\tfaces\n\t\t(');
    
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(13 15 9 3)');
    fprintf(FID, '\n\t\t\t(5 11 19 17)');
    fprintf(FID, '\n\t\t);\n\t}\n'); 
    
    %bottom
    fprintf(FID, '\n \tbottom \n\t{');
    fprintf(FID, '\n \t\ttype symmetryPlane;\n \t\tfaces\n\t\t(');
    
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(13 14 6 0)');
    fprintf(FID, '\n\t\t\t(2 8 18 16)');

    fprintf(FID, '\n\t\t);\n\t}\n'); 
    %obstacle 
    fprintf(FID, '\n \tobstacle  \n\t{');
    fprintf(FID, '\n \t\ttype patch;\n \t\tfaces\n\t\t(');
    
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(3 9 10 4)');
    fprintf(FID, '\n\t\t\t(4 10 11 5)');
    fprintf(FID, '\n\t\t\t(0 6 7 1)');
    fprintf(FID, '\n\t\t\t(1 7 8 2)');

    fprintf(FID, '\n\t\t);\n\t}\n'); 
    %end boundary
    fprintf(FID, '\n);');
    
   
end


