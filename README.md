# ProductsListTask

## Architecture and Design Patterns are used :

- The code provided follows the Model-View-ViewModel (MVVM) architecture pattern. This pattern is widely used in iOS applications and it is suitable with this project

- In addition to the MVVM architecture, the code also uses the Singleton design pattern for the CoreDataService class. This pattern ensures that only one instance of the class is created and provides a global point of access to that instance. The CoreDataService class is responsible for handling the local storage of the products fetched from the API, and it is used in the ViewModel to save and retrieve the products locally.

- Finally, the code also uses the Observer pattern to monitor the reachability status of the device's network. The Reachability class is used to detect changes in the network status, and the ViewModel registers an observer to receive notifications when the status changes. When a change is detected, the ViewModel either fetches the data from the API or retrieves it from the local storage, depending on the reachability status.
