.PHONY: clean test lint

TEST_PATH=./

help:
	@echo "    train-nlu"
	@echo "        Train the natural language understanding using Rasa NLU."
	@echo "    train-model"
	@echo "        Train a dialogue model using Rasa core."
	@echo "    run-cmdline"
	@echo "        Starts the bot on the command line"
	@echo "    visualize"
	@echo "        Saves the story graphs into a file"

run-actions:
	python3 -m rasa_core_sdk.endpoint --actions demo.actions

train-model:
	python -m rasa_core.train -d domain.yml -s stories.md -o models/dialogue

train-nlu:
	python -m rasa_nlu.train -c nlu_config.yml --data testData.json -o models --fixed_model_name nlu --project current --verbose

run-cmdline:
	make run-actions&
	python3 -m rasa_core.run -d models/dialogue -u models/nlu/current --debug --endpoints endpoints.yml

visualize:
	python3 -m rasa_core.visualize -s data/core/ -d domain.yml -o story_graph.png

train-online:
	python -m rasa_core.train -u models/nlu/current/ --online --core models/dialogue/

evaluate:
	python -m rasa_core.evaluate -d models/dialogue -s data/core/