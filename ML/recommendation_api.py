from flask import Flask, request, jsonify
import pickle
import os

app = Flask(__name__)

# Path to the model file
MODEL_FILE = 'event_recommendation_model.pkl'

# Check if model exists, otherwise show error
if not os.path.exists(MODEL_FILE):
    print(f"ERROR: Model file {MODEL_FILE} not found. Please run train_model.py first.")
else:
    # Load the model when the server starts
    print("Loading recommendation model...")
    with open(MODEL_FILE, 'rb') as f:
        model_data = pickle.load(f)
    
    pmf = model_data['model']
    user_mapping = model_data['user_mapping']
    reverse_item_mapping = model_data['reverse_item_mapping']
    print("Model loaded successfully!")

@app.route('/api/recommendations', methods=['GET'])
def get_recommendations():
    """API endpoint to get event recommendations for a user"""
    user_id = request.args.get('user_id')
    
    if not os.path.exists(MODEL_FILE):
        return jsonify({
            'error': 'Model not trained yet. Please train the model first.',
            'recommendations': []
        }), 500
    
    # Handle case where user ID doesn't exist in our training data
    if user_id not in user_mapping:
        print(f"User {user_id} not found in training data. Returning empty recommendations.")
        return jsonify({'recommendations': []})
    
    try:
        # Get user index
        user_idx = user_mapping[user_id]
        
        # Get recommendations (top 5)
        recommendations = pmf.recommend(user_idx, top_n=5)
        
        # Map back to organizer IDs
        organizer_ids = [reverse_item_mapping[item_idx] for item_idx in recommendations]
        
        return jsonify({'recommendations': organizer_ids})
    
    except Exception as e:
        print(f"Error generating recommendations: {e}")
        return jsonify({
            'error': str(e),
            'recommendations': []
        }), 500

@app.route('/api/status', methods=['GET'])
def status():
    """Simple endpoint to check if the API is running"""
    return jsonify({'status': 'Online', 'model_loaded': os.path.exists(MODEL_FILE)})

if __name__ == '__main__':
    print("Starting recommendation API server...")
    app.run(host='0.0.0.0', port=5000, debug=True)