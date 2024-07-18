""" The application is developed by Kittipich "Luke" Aiumbhornsin
Created on December 20, 2023
Dev Run file of the application """
from myMY import createApp, systemInfo, systemVersion
from decouple import config as en_var  # import the environment var
from time import localtime, strftime
# import pytz

print(f"System version: {systemVersion}", "\n[",
      strftime("%Y-%m-%d @%H:%M:%S", localtime()), "]")

# print(pytz.all_timezones) # List out all the timezone available
""" for running in dev """
if __name__ == '__main__':
    app = createApp()
    app.run(port=int(en_var("PORT", 5500)),
            debug=en_var("DEBUG", True))
