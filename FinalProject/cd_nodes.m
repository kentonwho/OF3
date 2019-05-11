clear all; clc; close all;

inlet_d = 1;
choke_d = .01;
outlet_d = 1;

choke_length = .00001;
inlet_angle = pi/6; 
outlet_angle = pi/6;

inlet_length = 1;
outlet_length = 1;

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
    fprintf(FID, 'hex(0 1 5 4 8 9 13 12) (20 20 1) simpleGrading (1 1 1)\n');
    fprintf(FID, 'hex(1 2 6 5 9 10 14 13) (20 20 1) simpleGrading (1 1 1)\n');
    fprintf(FID, 'hex(2 3 7 6 10 11 15 14) (20 20 1) simpleGrading (1 1 1)\n');
    fprintf(FID, ')\n\n');
    
    % Boundary
    fprintf(FID, 'boundary\n(\n');
    %inlet
    fprintf(FID, '\n \tinlet \n\t{');
    fprintf(FID, '\n \t\ttype patch;\n \t\tfaces\n\t\t(');
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(0 8 12 4)');
    fprintf(FID, '\n\t\t);\n\t}\n'); 
    
    %outlet
    fprintf(FID, '\n \toutlet \n\t{');
    fprintf(FID, '\n \t\ttype patch;\n \t\tfaces\n\t\t(');
    
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(3 11 15 7)');
    fprintf(FID, '\n\t\t);\n\t}\n'); 
    
    %top
    fprintf(FID, '\n \ttop \n\t{');
    fprintf(FID, '\n \t\ttype symmetryPlane;\n \t\tfaces\n\t\t(');
    
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(4 12 13 5)');
    fprintf(FID, '\n\t\t\t(5 13 14 6)');
    fprintf(FID, '\n\t\t\t(6 14 15 7)');
    fprintf(FID, '\n\t\t);\n\t}\n'); 
    
    %bottom
    fprintf(FID, '\n \tbottom \n\t{');
    fprintf(FID, '\n \t\ttype symmetryPlane;\n \t\tfaces\n\t\t(');
    
    % Probably hard code the faces
    fprintf(FID, '\n\t\t\t(0 8 9 1)');
    fprintf(FID, '\n\t\t\t(1 9 10 2)');
    fprintf(FID, '\n\t\t\t(2 10 11 3)');

    fprintf(FID, '\n\t\t);\n\t}\n'); 
    
    %end boundary
    fprintf(FID, '\n);');
    
   
end


