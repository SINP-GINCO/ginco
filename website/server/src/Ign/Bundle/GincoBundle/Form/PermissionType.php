<?php

namespace Ign\Bundle\GincoBundle\Form;

use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\OptionsResolver\OptionsResolver;

use Doctrine\ORM\EntityRepository;

use Ign\Bundle\GincoBundle\Entity\Website\Permission;
use Ign\Bundle\GincoBundle\Validator\Constraints\SavedRequestPermissions;



/**
 * Formulaire de choix des permissions
 * @author rpas
 *
 */
class PermissionType extends AbstractType {
	
	/**
	 * 
	 * {@inheritDoc}
	 * @see \Symfony\Component\Form\AbstractType::configureOptions()
	 */
	public function configureOptions(OptionsResolver $resolver) {
		
		$resolver->setDefaults(array(
			'class' => Permission::class,
			'choice_label' => 'label',
			'multiple' => true,
			'expanded' => true,
			'constraints' => array(
				new SavedRequestPermissions()
			),
			'query_builder' => function (EntityRepository $er) {
				return $er->createQueryBuilder('p')
					->join('p.group', 'g')
					->addOrderBy('g.label', 'ASC')
					->addOrderBy('p.label', 'ASC')
				;
			}
		));
	}
	
	
	/**
	 * 
	 * {@inheritDoc}
	 * @see \Symfony\Component\Form\AbstractType::getParent()
	 */
	public function getParent() {
		
		return EntityType::class ;
	}
}

