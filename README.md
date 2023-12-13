<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<h3 align="center">Bookify</h3>

  <p align="center">
    On entering the IIT Roorkee campus, many enthusiastic students have high expectations of leading a healthy lifestyle that includes body fitness and exploring a variety of skills by trying out different sports. But there is a major problem faced by many of these students, for example - students have experienced frequent situations wherein they go to play a sport or use a facility, e.g., table tennis but they rarely get a chance to actually play those games because they always remain occupied.This app aims to solve this problem. Has DRF powering the backend , and Flutter powering the frontend. 
    <br />
    <a href="https://github.com/pranavkonidena/Bookify_Frontend/issues">Report Bug</a>
    ·
    <a href="https://github.com/pranavkonidena/Bookify_Frontend/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- GETTING STARTED -->
## Getting Started
Please follow the instructions for setting up the frontend locally, Also go through the [Backend](https://github.com/pranavkonidena/Bookify_Backend) for instructions to create local databases and run the server

### Prerequisites

Flutter is required for setting up the frontend locally
* [Flutter](https://docs.flutter.dev/get-started/install)

### Installation
1. Clone the repo
   ```sh
   git clone https://github.com/pranavkonidena/Bookify_Frontend.git
   ```
2. Change working directory
   ```sh
   cd Bookify_Frontend
   ```
4. Run the flutter app
   ```flutter
   flutter run --release
   ```


<!-- USAGE EXAMPLES -->
## Some Screens and Features
This app is mainly divided into 2 sections:

* For Students
* For Amenity Heads
<br>
Amenity heads are the person's who manage all the things related to an amenity (eg Table Tennis Court) such as Adding new events, scheduling downtime for an amenity etc. They will also handle the booking and check whether these amenities will be available for booking or not. Amenity Heads have to login via their email and password whereas students can login using the Omniport OAuth2 by just tapping on the Channeli button.
<br>
<br>
<img src = "https://github.com/pranavkonidena/Bookify_Frontend/assets/122373207/67c8d1a1-29e4-454c-8d28-36a4f81a62f3" height = 350 width= 175>
<img src = "https://github.com/pranavkonidena/Bookify_Frontend/assets/122373207/5c9d0982-cca4-4c06-881c-d9c0e21057c9" height = 350 width= 175>
<img src = "https://github.com/pranavkonidena/Bookify_Frontend/assets/122373207/0e425f6e-b089-487c-8c3e-38c5f9489d12" height = 350 width= 175>
<img src = "https://github.com/pranavkonidena/Bookify_Frontend/assets/122373207/58683db6-1746-4e11-a21d-0621fcfcac78" height = 350 width= 175>
<img src = "https://github.com/pranavkonidena/Bookify_Frontend/assets/122373207/c5ccd0f1-b25a-4f66-a057-b39ba6db0c60" height = 350 width= 175>
<img src = "https://github.com/pranavkonidena/Bookify_Frontend/assets/122373207/727110bb-a0df-4f25-8682-5c080bc3b9ed" height = 350 width= 175>
<img src = "https://github.com/pranavkonidena/Bookify_Frontend/assets/122373207/263cb540-5f41-49a7-bc79-df2a01445eee" height = 350 width= 175>
<img src = "https://github.com/pranavkonidena/Bookify_Frontend/assets/122373207/b92b7a04-8188-423c-b662-f536ae7337f5" height = 350 width= 175>
<img src = "https://github.com/pranavkonidena/Bookify_Frontend/assets/122373207/e7ecd4bd-419f-4064-87eb-9f9f303d4ee9" height = 350 width= 175>
<img src = "https://github.com/pranavkonidena/Bookify_Frontend/assets/122373207/8907dfec-60d9-4912-9f09-0f95678a08d1" height = 350 width= 175>
<br>
<br>


### Booking and Cancellation
Users can reserve slots in student clubs and sports facilities based on their availability, and they can also cancel these reservations.
<br>


### Groups 
Users can form groups and book for a slot collectively, and every group member will receive the booking details.
<br>


### Teams
Users can create teams to provide events. The user who creates the team is assigned as the team admin of the team, and he can add further admins.
<br>

### Admin Dashboard
The admin can see all the booking details of these amenities and can revoke them.
<br>

### Event Creation
Team admin can create events and assign slots for booking of these events.
<br>


### Team Chat
All the team members can also contact and chat with each other in a team.


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- CONTACT -->
## Contact

Pranav Konidena - [@pranavkonidena](https://instagram.com/pranavkonidena) - pranav474738@gmail.com

[https://github.com/pranavkonidena/Bookify_Frontend](https://github.com/pranavkonidena/Bookify_Frontend)


## Built With

 <img src = "https://static.djangoproject.com/img/logos/django-logo-negative.svg" height = 40 width = 120>
 <img src = "https://storage.googleapis.com/cms-storage-bucket/847ae81f5430402216fd.svg" height = 40 width = 120>
 <img src = "https://omniport.readthedocs.io/en/latest/_images/op_wordmark.png" height = 40 width = 120>
 


<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

[Aryan](https://github.com/just-ary27) , [Akhil](https://github.com/Ak216puniA)

Made with ♥ , Pranav Konidena


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/pranavkonidena/Bookify_Frontend.svg?style=for-the-badge
[contributors-url]: https://github.com/pranavkonidena/Bookify_Frontend/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/pranavkonidena/Bookify_Frontend.svg?style=for-the-badge
[forks-url]: https://github.com/pranavkonidena/Bookify_Frontend/network/members
[stars-shield]: https://img.shields.io/github/stars/pranavkonidena/Bookify_Frontend.svg?style=for-the-badge
[stars-url]: https://github.com/pranavkonidena/Bookify_Frontend/stargazers
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/pranav-konidena-45102b25b
[https://github.com/pranavkonidena/Bookify_Frontend/assets/122373207/441a31c4-e32b-499f-a20d-dead6d00fc1d]: images/screenshot.png
[Django]: https://static.djangoproject.com/img/logos/django-logo-positive.svg
[Django-url]: https://www.djangoproject.com/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
