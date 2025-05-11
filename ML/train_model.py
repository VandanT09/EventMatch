import pandas as pd
import pickle
from cornac.data import Dataset
from cornac.eval_methods import RatioSplit
from cornac.models import PMF
from cornac.metrics import Precision, Recall, NDCG

print("Starting model training...")

# ----------------------------
# 1. Load Data
# ----------------------------
print("Loading data...")
event_details = pd.read_excel("Eventdetails.xlsx")
user_activity = pd.read_excel("User_Activity.xlsx")

# ----------------------------
# 2. Preprocess Data
# ----------------------------
print("Preprocessing data...")
# Map 'Swipe Action' to binary
user_activity['Swipe Action'] = user_activity['Swipe Action'].map({'Right': 1, 'Left': 0})

# Merge with event details to get full context
merged = pd.merge(user_activity, event_details, on='Organiser ID', how='inner')

# Encode users and items as numeric indices
user_mapping = {user_id: idx for idx, user_id in enumerate(merged['User ID'].unique())}
item_mapping = {item_id: idx for idx, item_id in enumerate(merged['Organiser ID'].unique())}

merged['user_idx'] = merged['User ID'].map(user_mapping)
merged['item_idx'] = merged['Organiser ID'].map(item_mapping)

# Create reverse mappings (for later use)
reverse_user_mapping = {idx: user_id for user_id, idx in user_mapping.items()}
reverse_item_mapping = {idx: item_id for item_id, idx in item_mapping.items()}

# ----------------------------
# 3. Prepare Data for Cornac
# ----------------------------
print("Preparing data for model...")
cornac_data = merged[['user_idx', 'item_idx', 'Swipe Action']]
cornac_data.columns = ['user', 'item', 'rating']
cornac_list = cornac_data.values.tolist()

# ----------------------------
# 4. Setup Evaluation Method
# ----------------------------
print("Setting up evaluation...")
eval_method = RatioSplit(data=cornac_list,
                         rating_threshold=0.5,
                         test_size=0.2,
                         exclude_unknowns=True,
                         verbose=True)

# ----------------------------
# 5. Train PMF Model
# ----------------------------
print("Training model...")
pmf = PMF(k=10, learning_rate=0.01, lambda_reg=0.01, max_iter=50, verbose=True)
pmf.fit(eval_method.train_set)

# ----------------------------
# 6. Evaluate Model
# ----------------------------
print("Evaluating model...")
results = eval_method.evaluate(model=pmf,
                               metrics=[
                                   Precision(k=5), Recall(k=5), NDCG(k=5),
                                   Precision(k=10), Recall(k=10), NDCG(k=10)
                               ])

# Print evaluation metrics
print("\nEvaluation Results:")
for metric in results:
    print(f"{metric.metric}: {metric.score:.4f}")

# ----------------------------
# 7. Save Model and Mappings
# ----------------------------
print("Saving model to file...")
model_data = {
    'model': pmf,
    'user_mapping': user_mapping,
    'item_mapping': item_mapping,
    'reverse_user_mapping': reverse_user_mapping,
    'reverse_item_mapping': reverse_item_mapping
}

with open('event_recommendation_model.pkl', 'wb') as f:
    pickle.dump(model_data, f)

print("Model training and saving complete!")