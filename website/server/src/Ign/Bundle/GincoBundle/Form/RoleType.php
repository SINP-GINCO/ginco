<?php
namespace Ign\Bundle\GincoBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Ign\Bundle\GincoBundle\Entity\Website\Role;
use Ign\Bundle\GincoBundle\Entity\Website\Permission;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Ign\Bundle\GincoBundle\Entity\Metadata\Dataset;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableSchema;
use Doctrine\ORM\EntityRepository;
use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
use Ign\Bundle\GincoBundle\Validator\Constraints\SavedRequestPermissions;

class RoleType extends AbstractType {

	/**
	 * Build the role form.
	 *
	 * @param FormBuilderInterface $builder        	
	 * @param array $options        	
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {
		if ($options['data']->getLabel() == 'Grand public') {
			$button_inactive = true;
		} else {
			$button_inactive = false;
		}
		
		$builder->add('label', TextType::class, array(
			'label' => 'Label',
			'disabled' => $button_inactive
		))
			->add('definition', TextType::class, array(
			'label' => 'Definition',
			'required' => false,
			'disabled' => $button_inactive
		))
			->add('isDefault', CheckboxType::class, array(
			'label' => 'Rôle par défaut',
			'required' => false,
			'disabled' => true,
			'attr' => array(
				'data-toggle' => 'tooltip',
				'data-placement' => 'left',
				'title' => 'Role.edit.default'
			)
		))
			->add('permissions', EntityType::class, array(
			'label' => 'Permissions',
			'class' => Permission::class,
			'choice_label' => 'label',
			'multiple' => true,
			'expanded' => true,
			'disabled' => $button_inactive,
			'constraints' => array(
				new SavedRequestPermissions()
			),
			'query_builder' => function (EntityRepository $er) {
				return $er->createQueryBuilder('d')
					->orderBy('d.label', 'ASC');
			}
		))
			->add('schemas', EntityType::class, array(
			'label' => 'Schemas Permissions',
			'class' => TableSchema::class,
			'choice_label' => 'label',
			'multiple' => true,
			'expanded' => true,
			'query_builder' => function (EntityRepository $er) {
				$qb = $er->createQueryBuilder('s');
				$exp = $qb->expr()
					->in('s.code', array(
					'RAW_DATA'
				));
				return $qb->where($exp);
			}
		))
			->add('datasets', EntityType::class, array(
			'label' => 'Datasets Restrictions',
			'class' => Dataset::class,
			'choice_label' => 'label',
			'multiple' => true,
			'expanded' => true
		))
			->
		add('submit', SubmitType::class, array(
			'label' => 'Submit'
		));
	}

	/**
	 *
	 * @param OptionsResolver $resolver        	
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => Role::class
		));
	}
}
