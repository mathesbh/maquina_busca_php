#!/usr/bin/php
<?php

use App\Engine\Wikipedia\WikipediaEngine;
use App\Engine\Wikipedia\WikipediaParser;
use Symfony\Component\Console\Application;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Helper\Table;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\HttpClient\HttpClient;

require 'vendor/autoload.php';

class WikipediaCommand extends Command{
  protected function configure()
  {
    $this
      ->setName('pesquisar')
      ->setDescription('Pesquisador de conteúdo na Wikipedia')
      ->addArgument('conteudo', InputArgument::REQUIRED, 'Conteúdo a ser pesquisado');
  }

  protected function execute(InputInterface $input, OutputInterface $output)
  {
    $wikipedia = new WikipediaEngine(new WikipediaParser(), HttpClient::create());
    $result = $wikipedia->search($input->getArgument('conteudo'));
    foreach ($result as $value) {
      $rows[] = [$value->getTitle(), $value->getPreview()];
    }

    $table = new Table($output);
    $table->setHeaders(['Título', 'Resumo'])->setRows($rows);
    $table->render();
    return 0;
  }
}

$app = new Application();
$app->add(new WikipediaCommand());
$app->run();

