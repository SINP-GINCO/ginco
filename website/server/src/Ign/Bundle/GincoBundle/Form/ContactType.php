<?php
namespace Ign\Bundle\GincoBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Validator\Constraints\Blank;
use Symfony\Component\Validator\Constraints\Email;
use Symfony\Component\Validator\Constraints\NotBlank;
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
            ->add('sender', TextType::class, array(
                'label' => 'Contact.sender',
                'constraints' => array(
                    new NotBlank(array('message' => 'Contact.validation.sender.notblank'))
                ),
            ))
            ->add('job', TextType::class, array(
                'label' => 'Contact.job',
                'required' => false
            ))
            ->add('email', EmailType::class, array(
                'label' => 'Contact.email',
                'constraints' => array(
                    new NotBlank(array('message' => 'Contact.validation.email.notblank')),
                    new Email(array('message' => 'Contact.validation.email.invalid')),
                ),
            ))
            ->add('subject', ChoiceType::class, array(
                'label' => 'Contact.subject.title',
                'choices' => array(
                    'Contact.subject.format.title' => array(
                        'Contact.subject.format.standard' => 'Contact.subject.format.standard',
                        'Contact.subject.format.structure' => 'Contact.subject.format.structure',
                        'Contact.subject.format.taxref' => 'Contact.subject.format.taxref',
                        'Contact.subject.format.sensitivity' => 'Contact.subject.format.sensitivity',
                    ),
                    'Contact.subject.rules.title' => array(
                        'Contact.subject.rules.architecture' => 'Contact.subject.rules.architecture',
                        'Contact.subject.rules.protocol' => 'Contact.subject.rules.protocol',
                        'Contact.subject.rules.relation' => 'Contact.subject.rules.relation',
                        'Contact.subject.rules.validation' => 'Contact.subject.rules.validation',
                    ),
                    'Contact.subject.operation.title' => array(
                        'Contact.subject.operation.organism' => 'Contact.subject.operation.organism',
                        'Contact.subject.operation.metadata' => 'Contact.subject.operation.metadata',
                        'Contact.subject.operation.ginco' => 'Contact.subject.operation.ginco',
                        'Contact.subject.operation.import' => 'Contact.subject.operation.import',
                        'Contact.subject.operation.gincoWorkflow' => 'Contact.subject.operation.gincoWorkflow'
                    ),
                    'Contact.subject.blocking.title' => array(
                        'Contact.subject.blocking.ginco' => 'Contact.subject.blocking.ginco',
                        'Contact.subject.blocking.metadata' => 'Contact.subject.blocking.metadata',
                        'Contact.subject.blocking.authentication' => 'Contact.subject.blocking.authentication',
                        'Contact.subject.blocking.sinpDirectory' => 'Contact.subject.blocking.sinpDirectory'
                    ),
                    'Contact.subject.evolution.title' => array(
                        'Contact.subject.evolution.ginco' => 'Contact.subject.evolution.ginco',
                        'Contact.subject.evolution.dldbb' => 'Contact.subject.evolution.dldbb',
                        'Contact.subject.evolution.metadata' => 'Contact.subject.evolution.metadata',
                        'Contact.subject.evolution.directory' => 'Contact.subject.evolution.directory'
                    ),
                    'Contact.subject.other'=> 'Contact.subject.other'
                ),
                'choices_as_values' => true,
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