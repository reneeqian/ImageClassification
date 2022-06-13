classdef SmokeTests < matlab.unittest.TestCase
    
    properties (TestParameter)
        DemoFile = struct( ... 
			'TransferLearning_ImageClassification', {@TransferLearning_ImageClassification});
    end    
    
    methods (TestClassSetup)
        
        % Shut off graphics warnings
        function killGraphicsWarning(testCase)
            ws = warning('off', 'MATLAB:hg:AutoSoftwareOpenGL');
            testCase.addTeardown(@()warning(ws));
            
        end
        
        % Close any new figures created by doc
        function saveExistingFigures(testCase)            
            existingfigs = findall(groot, 'Type', 'Figure');
            testCase.addTeardown(@()delete(setdiff(findall(groot, 'Type', 'Figure'), existingfigs)))
            
        end
        
    end
    
    methods (Test)
        
        function demoShouldNotWarn(testCase, DemoFile)       
            testCase.verifyWarningFree(DemoFile);
        end
        
        function importfcnresizetest(testCase)
            inputSize = [10,10];
            testCase.verifySize(myImgImportFcn("peppers.png",inputSize),[inputSize, 3]);
        end

        function thistestwillerror(testCase)
            testCase.verifyTrue(false)
        end
        
    end

end
