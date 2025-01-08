import React from 'react'
import { HeroContainer, HeroBg, HeroLeftContainer, Img, HeroRightContainer, HeroInnerContainer, TextLoop, Title, Span, SubTitle,ButtonContainer,SocialMediaIcons,SocialMediaIcon, ResumeButton } from './HeroStyle'
import HeroImg from '../../images/HeroImage.JPG'
import Typewriter from 'typewriter-effect';
import { Bio } from '../../data/constants';
import DescriptionIcon from '@mui/icons-material/Description';
import MailIcon from '@mui/icons-material/Mail';
import LinkedInIcon from '@mui/icons-material/LinkedIn';
import GithubIcon from '@mui/icons-material/GitHub';

// Faster Text Loop Component
const FasterTextLoop = () => {
    return (
        <TextLoop>
            <TextLoop interval={1000}> {/* Adjust the interval to make the loop faster */}
                {Bio.roles.map((role, index) => (
                    <span key={index}>
                        <Typewriter
                            options={{
                                strings: [role],
                                autoStart: true,
                                loop: true,
                                delay: 50, // Adjust typing speed
                                deleteSpeed: 30, // Adjust deleting speed
                                pauseFor: 500, // Adjust the pause duration before starting to delete
                            }}
                        />
                    </span>
                ))}
            </TextLoop>
        </TextLoop>
    );
  };
const HeroSection = () => {
    return (
        <div id="about">
            <HeroContainer>
                <HeroInnerContainer >
                    <HeroLeftContainer id="Left">
                        <Title>Hi, I am <br /> {Bio.name}</Title>
                        <TextLoop>
                            <Span>
                                <Typewriter
                                    options={{
                                        strings: Bio.roles,
                                        autoStart: true,
                                        loop: true,
                                    }}
                                />
                            </Span>
                        </TextLoop>
                        <SubTitle>{Bio.description}</SubTitle>
                        <SubTitle>{Bio.description2}</SubTitle>
                        <SocialMediaIcons>
                            <SocialMediaIcon href={Bio.github} target="display"><GithubIcon /></SocialMediaIcon>
                            <SocialMediaIcon href={Bio.linkedin} target="display"><LinkedInIcon /></SocialMediaIcon>
                            <SocialMediaIcon href={Bio.email} target="display"><MailIcon /></SocialMediaIcon>
                            <SocialMediaIcon href={Bio.resume} target="display"><DescriptionIcon /></SocialMediaIcon>
                        </SocialMediaIcons>
                    </HeroLeftContainer>

                    <HeroRightContainer id="Right">

                        <Img src={HeroImg} alt="hero-image"/>
                    </HeroRightContainer>
                </HeroInnerContainer>

            </HeroContainer>
        </div>
    )
}

export default HeroSection