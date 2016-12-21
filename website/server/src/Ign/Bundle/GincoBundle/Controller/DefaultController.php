<?php

namespace Ign\Bundle\GincoBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;

class DefaultController extends Controller
{
    public function indexAction()
    {
        return $this->render('IgnGincoBundle:Default:index.html.twig');
    }
}
