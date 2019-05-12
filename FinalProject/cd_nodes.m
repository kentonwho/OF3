clear all; clc; close all;

inlet_d = .025;
choke_d = .01;
outlet_d = .035;

choke_length = .01;
inlet_angle = .27494; 
outlet_angle = .25568;

inlet_length = .02762528;
outlet_length = .050;

node(1,:) = [0 0 0];
node(2,:) = [inlet_length*cos(inlet_angle) inlet_length*sin(inlet_angle) 0];
node(3,:) = [inlet_length*cos(inlet_angle)+choke_length inlet_length*sin(inlet_angle) 0];
node(4,:) = [node(3,1)+outlet_length*cos(outlet_angle) node(3,2)-outlet_length*sin(outlet_angle) 0];

node(5,:) =[node(1,1) node(1,2)+inlet_d 0];  
node(6,:) =[node(2,1) node(2,2)+choke_d 0];
node(7,:) =[node(3,1) node(3,2)+choke_d 0];
node(8,:) = [node(4,1) node(4,2)+outlet_d 0];
for i=9:16
   node(i,:) = [node(i-8,1:2) .01]; 
end
node(17,:) = [-.01 0 0];
node(18,:) = [-.01 inlet_d 0];
node(19,:) = [-.01 0 .01];
node(20,:) = [-.01 inlet_d .01];
node(21,:) = [node(4,1)+.01 node(4,2) 0];
node(22,:) = [node(4,1)+.01 node(4,2)+outlet_d 0];
node(23,:) = [node(4,1)+.01 node(4,2) .01];
node(24,:) = [node(4,1)+.01 node(4,2)+outlet_d .01];

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
    fprintf(FID, 'hex (0 1 5 4 8 9 13 12) (20 20 1) simpleGrading (1 1 1)\n');
    fprintf(FID, 'hex (1 2 6 5 9 10 14 13) (20 20 1) simpleGrading (1 1 1)\n');
    fprintf(FID, 'hex (2 3 7 6 10 11 15 14) (20 20 1) simpleGrading (1 1 1)\n');
    fprintf(FID, 'hex (16 0 4 17 18 8 12 19) (20 20 1) simpleGrading (1 1 1)\n');
    fprintf(FID, 'hex (3 20 21 7 11 22 23 15) (20 20 1) simpleGrading (1 1 1)\n');
    fprintf(FID, ');\n\n');
    
    % Boundary
    fprintf(FID, 'boundary\n(\n');
    %inlet
    fprintf(FID, '\n \tinlet \n\t{');
    fprintf(FID, '\n \t\ttype patch;\n \t\tfaces\n\t\t(');
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(16 18 19 17)');
    fprintf(FID, '\n\t\t);\n\t}\n'); 
    
    %outlet
    fprintf(FID, '\n \toutlet \n\t{');
    fprintf(FID, '\n \t\ttype patch;\n \t\tfaces\n\t\t(');
    
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(20 22 23 21)');
    fprintf(FID, '\n\t\t);\n\t}\n'); 
    
    %top
    fprintf(FID, '\n \ttop \n\t{');
    fprintf(FID, '\n \t\ttype symmetryPlane;\n \t\tfaces\n\t\t(');
    
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(17 19 12 4)');
    fprintf(FID, '\n\t\t\t(7 15 23 21)');
    fprintf(FID, '\n\t\t);\n\t}\n'); 
    
    %bottom
    fprintf(FID, '\n \tbottom \n\t{');
    fprintf(FID, '\n \t\ttype symmetryPlane;\n \t\tfaces\n\t\t(');
    
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(16 18 8 0)');
    fprintf(FID, '\n\t\t\t(3 11 22 20)');

    fprintf(FID, '\n\t\t);\n\t}\n'); 
    %obstacle 
    fprintf(FID, '\n \tobstacle  \n\t{');
    fprintf(FID, '\n \t\ttype patch;\n \t\tfaces\n\t\t(');
    
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(4 12 13 5)');
    fprintf(FID, '\n\t\t\t(5 13 14 6)');
    fprintf(FID, '\n\t\t\t(6 14 15 7)');
    fprintf(FID, '\n\t\t\t(0 8 9 1)');
    fprintf(FID, '\n\t\t\t(1 9 10 2)');
    fprintf(FID, '\n\t\t\t(2 10 11 3)');

    fprintf(FID, '\n\t\t);\n\t}\n'); 
    %end boundary
    fprintf(FID, '\n);');
    
   
end


