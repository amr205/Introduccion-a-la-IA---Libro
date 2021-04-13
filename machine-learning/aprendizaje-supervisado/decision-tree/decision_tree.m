# We are going to build a decision tree for a toy dataset,
# In this dataset we classify loans safety, we have safe loans and bad loans
# We only have categorical features and they are binary encoded, for example
# feature  =    {'home_ownership': 'RENT'}
# becomes the following three features
# { 
#   'home_ownership = OWN'      : 0, 
#   'home_ownership = MORTGAGE' : 0, 
#   'home_ownership = RENT'     : 1
# }

# --- Load dataset ---
clear
features = {'safe_loans','grade.A','grade.B','grade.C','grade.D','grade.E','grade.F','grade.G','term. 36 months','term. 60 months','home_ownership.MORTGAGE','home_ownership.OTHER','home_ownership.OWN','home_ownership.RENT','emp_length.1 year','emp_length.10+ years','emp_length.2 years','emp_length.3 years','emp_length.4 years','emp_length.5 years','emp_length.6 years','emp_length.7 years','emp_length.8 years','emp_length.9 years','emp_length.< 1 year','emp_length.n/a'};
dataset = dlmread('loan_data.csv',',',1,0);

#Function to calculate node num mistakes
function num_mistakes = intermediate_node_num_mistakes(labels_in_node)
    # Corner case: If labels_in_node is empty, return 0
    if(length(labels_in_node) == 0)
        num_mistakes=0;
    endif
    # Count the number of 1's (safe loans)
    safe = sum(labels_in_node == 1);
    # Count the number of -1's (risky loans)
    risky = sum(labels_in_node == -1);
    # Return the number of mistakes that the majority classifier makes.
    if(safe > risky)
      num_mistakes=risky;
    else
      num_mistakes=safe;
    endif
endfunction
#FUNCTION TESTING CODE (Expected 2)
#mistakes = intermediate_node_num_mistakes([1,1,1,-1,-1])

#Function to calculate best feature to split onCleanup
function [best_feature,best_feature_idx,best_error] = best_splitting_feature(data, features, target_idx)
    best_idx = 0;
    best_feature = '';  # Keep track of the best feature 
    best_error = 10;     # Keep track of the best error so far 
    num_data_points = size(data,1);
    
    # Loop through each feature to consider splitting on that feature
    for feature_idx = 2:length(features)     
        feature = features{1,feature_idx};
        # The left split will have all data points where the feature value is 0
        left_split = data( ismember(data(:,feature_idx), 0), :);
        
        # The right split will have all data points where the feature value is 1
        right_split =  data( ismember(data(:,feature_idx), 1), :);
 
        # Calculate the number of misclassified examples in the left split.
        # Remember that we implemented a function for this! (It was called intermediate_node_num_mistakes)
        left_mistakes = intermediate_node_num_mistakes(left_split(:,target_idx));

        # Calculate the number of misclassified examples in the right split.
        right_mistakes = intermediate_node_num_mistakes(right_split(:,target_idx));
            
        # Compute the classification error of this split.
        # Error = (# of mistakes (left) + # of mistakes (right)) / (# of data points)
        error = (left_mistakes+right_mistakes)/num_data_points;

        # If this is the best error we have found so far, store the feature as best_feature and the error as best_error
        if(error < best_error)
            best_feature_idx = feature_idx;
            best_feature = feature;
            best_error = error;
        endif
    endfor
endfunction
#FUNCTION TESTING CODE (Expected best_feature = term. 36 months, best_idx =  9, best_error =  0.42197)
#target_idx = find(ismember(cellstr(features), 'safe_loans'));
#[best_feature,best_idx,best_error] = best_splitting_feature(dataset,features,target_idx)

#Every node in the tree will have the following structure
#{ 
#   'is_leaf'            : True/False. (1/0)
#   'prediction'         : Prediction at the leaf node.
#   'left'               : (dictionary corresponding to the left tree).
#   'right'              : (dictionary corresponding to the right tree).
#   'splitting_feature'  : The feature that this node splits on.
#   'splitting_feature_idx: The index of the feature that this node splits on.
#}

#Function used to create leaf nodes
function node = create_leaf(target_values)
    # Create a leaf node
    node.splitting_feature_idx = 0;
    node.splitting_feature = '';
    node.left = [];
    node.right = [];
    node.is_leaf = 1;  
    
    # Count the number of data points that are +1 and -1 in this node.
    num_ones = sum(target_values==1);
    num_minus_ones = sum(target_values==-1);
    
    # For the leaf node, set the prediction to be the majority class.
    # Store the predicted class (1 or -1) in leaf['prediction']
    if(num_ones > num_minus_ones)
        node.predictions = 1;
    else
        node.predictions = 1;
    endif
endfunction
#FUNCTION TESTING CODE 
#node = create_leaf([1,1,1,-1,-1])

#Function used to construct the Tree!!!
function node = decision_tree_create(data, features, target_idx, current_depth = 0, max_depth = 10)
    remaining_features = features(:)'; # Make a copy of the features.
    target_values = data(:,target_idx);

    # (Check if there are mistakes at current node)
    if  (intermediate_node_num_mistakes(target_values) == 0)  
        node = create_leaf(target_values);
    elseif (length(remaining_features) == 1)   
        # If there are no remaining features to consider, make current node a leaf node
        node = create_leaf(target_values);   
    elseif (current_depth >= max_depth)
        # If the max tree depth has been reached, make current node a leaf node
        node = create_leaf(target_values);
    else
      # Find the best splitting feature (recall the function best_splitting_feature implemented above)
      [splitting_feature,splitting_idx,_] = best_splitting_feature(data, remaining_features, target_idx);
      
      # Split on the best feature that we found. 
      left_split = data( ismember(data(:,splitting_idx), 0), :);
      right_split =  data( ismember(data(:,splitting_idx), 1), :);
      #Remove best feature
      remaining_features(ismember(remaining_features,splitting_feature)) = [];
      
      # Create a leaf node if the split is "perfect"
      if(size(left_split,1) == size(data,1))
          node =  create_leaf(left_split(:,target_idx));
      elseif (size(right_split,1) == size(data,1))
          node = create_leaf(right_split(:,target_idx));
      else
          # Repeat (recurse) on left and right subtrees
          left_tree = decision_tree_create(left_split, remaining_features, target_idx, current_depth + 1, max_depth);      
          right_tree = decision_tree_create(right_split, remaining_features, target_idx, current_depth + 1, max_depth);      
          node.splitting_feature_idx = splitting_idx;
          node.splitting_feature = splitting_feature;
          node.left = left_tree;
          node.right = right_tree;
          node.is_leaf = 0;
      endif
  endif
endfunction

#Function used to count nodes
function num = count_nodes(tree)
    if(tree.is_leaf == 1)
        num=1;
    else
        num =  1 + count_nodes(tree.left) + count_nodes(tree.right);
    endif
endfunction

#FUNCTION TESTING CODE 
#small_data_decision_tree = decision_tree_create(dataset, features, 1, 0, 3)
#count_nodes(small_data_decision_tree) (Expected 11)


#Function used to make predictions
function prediction = classify(tree, x)
    # if the node is a leaf node.
    if (tree.is_leaf==1)
        prediction = tree.predictions;
    else
        # split on feature.
        split_feature_value = x(tree.splitting_feature_idx);
        if(split_feature_value == 0)
            prediction = classify(tree.left, x);
        else
            prediction = classify(tree.right, x);
        endif
    endif
endfunction

#Test data
#{'safe_loans': 1,
# 'grade.A': 0,
# 'grade.B': 0,
# 'grade.C': 0,
# 'grade.D': 1,
# 'grade.E': 0,
# 'grade.F': 0,
# 'grade.G': 0,
# 'term. 36 months': 0,
# 'term. 60 months': 1,
# 'home_ownership.MORTGAGE': 0,
# 'home_ownership.OTHER': 0,
# 'home_ownership.OWN': 0,
# 'home_ownership.RENT': 1,
# 'emp_length.1 year': 0,
# 'emp_length.10+ years': 0,
# 'emp_length.2 years': 1,
# 'emp_length.3 years': 0,
# 'emp_length.4 years': 0,
# 'emp_length.5 years': 0,
# 'emp_length.6 years': 0,
# 'emp_length.7 years': 0,
# 'emp_length.8 years': 0,
# 'emp_length.9 years': 0,
# 'emp_length.< 1 year': 0,
# 'emp_length.n/a': 0}

#Create tree classifier
test_data=[1,0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0];
decision_tree = decision_tree_create(dataset, features, 1, 0, 10);
predicted = classify(decision_tree,test_data);
predicted