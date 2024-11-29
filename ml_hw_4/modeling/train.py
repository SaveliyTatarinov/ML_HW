import argparse
import itertools
import json

import joblib
import pandas as pd
import wandb
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, classification_report, confusion_matrix
from sklearn.model_selection import train_test_split

def train_and_log(config, dataset_path, experiment_name):
    if not isinstance(config, dict):
        raise TypeError(f"Invalid config type: {type(config)}. Expected dict.")

    param_combinations = list(itertools.product(*config.values()))

    data = pd.read_csv(dataset_path)
    X = data.iloc[:, :-1]
    y = data.iloc[:, -1]
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=73, stratify=y)

    for params in param_combinations:
        model_config = dict(zip(config.keys(), params))
        print(f"Training with config: {model_config}")

        experiment_name_unique = f"{experiment_name}_{'_'.join(map(str, params))}"
        wandb.init(project="ml_experiments", config=model_config, name=experiment_name_unique)

        model = LogisticRegression(
            **model_config
        )
        model.fit(X_train, y_train)

        predictions = model.predict(X_test)
        predictions_proba = model.predict_proba(X_test)

        accuracy = accuracy_score(y_test, predictions)
        precision = precision_score(y_test, predictions)
        recall = recall_score(y_test, predictions)
        f1 = f1_score(y_test, predictions)

        wandb.log({"Accuracy": accuracy, "Precision": precision, "Recall": recall, "F1-score": f1})
        wandb.log({"Prediction Probabilities": wandb.Table(dataframe=pd.DataFrame(predictions_proba), columns=[f"Class {i}" for i in range(predictions_proba.shape[1])])})

        model_path = f"output/{experiment_name_unique}_model_{str(params)}.pkl"
        try:
            joblib.dump(model, model_path)
            print(f"Model saved to {model_path}")
        except Exception as e:
            print(f"Failed to save model: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", type=str, required=True, help="Path to config JSON")
    parser.add_argument("--dataset", type=str, required=True, help="Dataset path")
    parser.add_argument("--experiment", type=str, required=True, help="Experiment name")
    args = parser.parse_args()

    with open(args.config) as f:
        config = json.load(f)

    train_and_log(config, args.dataset, args.experiment)