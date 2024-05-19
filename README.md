# myMY by LukeCreated

Personal Project: `myMY` is a Python based web app powered by Flask to keep track of spending and incoming.

## About

- Application is live at link: [mymy.lukecreated.com](https://mymy.lukecreated.com)

- Developer: **Kittipich "Luke" Aiumbhornsin**

- Development Status: **Beta Release**

- License information: **LICENSE** [go to file](LICENSE)

- Development history: **CHANGELOG.md** [go to file](CHANGELOG.md)

Current Status: **Beta Release**

Current Version: **0.7761**

Updated: **May 19, 2024**

## Instructions of running locally

1. change working directory on terminal using `cd` command to where the project will be saved

2. at the desire directory, clone the repo by run command:
`git clone https://github.com/ngzh-luke/self-myMY.git`

3. if already cloned, update the local repository by run command:
`git pull`

4. create virtual environment by run command:
`python -m venv venv`

5. check to see that the virtual is at the virtual environment is created by run command: `which pip`

6. activate virtual environment (macOS) by run command:
`source venv/bin/activate`
activate virtual environment (Windows) by run command: `venv\Scripts\activate`

7. install project dependencies by run command:
`pip install -r requirements.txt`

8. you may create `.env` file the same level as this `README.md` file and fill in to update default environment settings in the format like in `.example.env`, the default settings are:

    ```.env
    myMY=myMY_secret -> secret text of the Flask
    DATABASE_URL=sqlite:///myMY_db.sqlite -> database path
    port=5500 -> default running port
    ```

9. run command to start the application:
`python runDev.py`

10. check out the running application on browser by navigate to: `127.0.0.1:5500` or `127.0.0.1:[port you specify on .env]`

11. impressed by the cool application!

---

### TODO for developer

- get by amount
- get by date
