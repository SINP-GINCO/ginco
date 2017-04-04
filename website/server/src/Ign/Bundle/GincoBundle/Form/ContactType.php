<?php
namespace Ign\Bundle\GincoBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Validator\Constraints\Blank;
use Symfony\Component\Validator\Constraints\Email;
use Symfony\Component\Validator\Constraints\NotBlank;
use Symfony\Component\Validator\Constraints\Collection;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;

/**
 * Class ContactType
 * Contact form type
 * @package Ign\Bundle\GincoBundle\Form
 */
class ContactType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            // This field is a "honeypot", meant to confuse bots.
            // it is hidden in css, and must be left blank.
            // if not, we don't send the email.
            ->add('name', TextType::class, array(
                'label' => 'Contact.name',
                'required' => false,
                'attr' => array(
                    'class' => 'hidden'
                ),
                'label_attr' => array(
                    'class' => 'hidden'
                ),
                'constraints' => array(
                    new Blank(array('message' => 'Contact.validation.name.blank')),
                ),
            ))
            ->add('email', EmailType::class, array(
                'label' => 'Contact.email',
                'constraints' => array(
                    new NotBlank(array('message' => 'Contact.validation.email.notblank')),
                    new Email(array('message' => 'Contact.validation.email.invalid')),
                ),
            ))
            ->add('message', TextareaType::class, array(
                'label' => 'Contact.message',
                'attr' => array(
                    'cols' => 90,
                    'rows' => 10,
                ),
                'constraints' => array(
                    new NotBlank(array('message' => 'Contact.validation.message.notblank')),
                ),
            ))
            ->add('submit', SubmitType::class, array(
                'label' => 'Contact.send.button'
            ))
        ;
    }

    public function setDefaultOptions(OptionsResolverInterface $resolver)
    {
    }

    public function getName()
    {
        return 'contact_form';
    }
}